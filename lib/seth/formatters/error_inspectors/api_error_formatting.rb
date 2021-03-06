#--
# Author:: Daniel DeLeo (<dan@opscode.com>)
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Seth
  module Formatters

    module APIErrorFormatting

      NETWORK_ERROR_CLASSES = [Errno::ECONNREFUSED, Timeout::Error, Errno::ETIMEDOUT, SocketError]

      def describe_network_errors(error_description)
        error_description.section("Networking Error:",<<-E)
#{exception.message}

Your seth_server_url may be misconfigured, or the network could be down.
E
        error_description.section("Relevant Config Settings:",<<-E)
seth_server_url  "#{server_url}"
E
      end

      def describe_401_error(error_description)
        if clock_skew?
          error_description.section("Authentication Error:",<<-E)
Failed to authenticate to the seth server (http 401).
The request failed because your clock has drifted by more than 15 minutes.
Syncing your clock to an NTP Time source should resolve the issue.
E
        else
          error_description.section("Authentication Error:",<<-E)
Failed to authenticate to the seth server (http 401).
E

          error_description.section("Server Response:", format_rest_error)
          error_description.section("Relevant Config Settings:",<<-E)
seth_server_url   "#{server_url}"
node_name         "#{username}"
client_key        "#{api_key}"

If these settings are correct, your client_key may be invalid, or
you may have a seth user with the same client name as this node.
E
        end
      end

      def describe_400_error(error_description)
        error_description.section("Invalid Request Data:",<<-E)
The data in your request was invalid (HTTP 400).
E
        error_description.section("Server Response:",format_rest_error)
      end

      def describe_500_error(error_description)
        error_description.section("Unknown Server Error:",<<-E)
The server had a fatal error attempting to load the node data.
E
        error_description.section("Server Response:", format_rest_error)
      end

      def describe_503_error(error_description)
        error_description.section("Server Unavailable","The Seth Server is temporarily unavailable")
        error_description.section("Server Response:", format_rest_error)
      end


      # Fallback for unexpected/uncommon http errors
      def describe_http_error(error_description)
        error_description.section("Unexpected API Request Failure:", format_rest_error)
      end

      # Parses JSON from the error response sent by Seth Server and returns the
      # error message
      def format_rest_error
        Array(Seth::JSONCompat.from_json(exception.response.body)["error"]).join('; ')
      rescue Exception
        safe_format_rest_error
      end

      def username
        config[:node_name]
      end

      def api_key
        config[:client_key]
      end

      def server_url
        config[:seth_server_url]
      end

      def clock_skew?
        exception.response.body =~ /synchronize the clock/i
      end

      def safe_format_rest_error
        # When we get 504 from the server, sometimes the response body is non-readable.
        #
        # Stack trace:
        #
        # NoMethodError: undefined method `closed?' for nil:NilClass
        # .../lib/ruby/1.9.1/net/http.rb:2789:in `stream_check'
        # .../lib/ruby/1.9.1/net/http.rb:2709:in `read_body'
        # .../lib/ruby/1.9.1/net/http.rb:2736:in `body'
        # .../lib/seth/formatters/error_inspectors/api_error_formatting.rb:91:in `rescue in format_rest_error'
        begin
          exception.response.body
        rescue Exception
          "Cannot fetch the contents of the response."
        end
      end

    end
  end
end
