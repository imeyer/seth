#
# Author:: John Keiser (<jkeiser@opscode.com>)
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

require 'seth/chef_fs/file_system/base_fs_object'
require 'seth/http/simple'
require 'digest/md5'

class Seth
  module SethFS
    module FileSystem
      class CookbookFile < BaseFSObject
        def initialize(name, parent, file)
          super(name, parent)
          @file = file
        end

        attr_reader :file

        def checksum
          file[:checksum]
        end

        def read
          begin
            tmpfile = rest.streaming_request(file[:url])
          rescue Timeout::Error => e
            raise Seth::ChefFS::FileSystem::OperationFailedError.new(:read, self, e), "Timeout reading #{file[:url]}: #{e}"
          rescue Net::HTTPServerException => e
            raise Seth::ChefFS::FileSystem::OperationFailedError.new(:read, self, e), "#{e.message} retrieving #{file[:url]}"
          end

          begin
            tmpfile.open
            tmpfile.read
          ensure
            tmpfile.close!
          end
        end

        def rest
          parent.rest
        end

        def compare_to(other)
          other_value = nil
          if other.respond_to?(:checksum)
            other_checksum = other.checksum
          else
            begin
              other_value = other.read
            rescue Seth::ChefFS::FileSystem::NotFoundError
              return [ false, nil, :none ]
            end
            other_checksum = calc_checksum(other_value)
          end
          [ checksum == other_checksum, nil, other_value ]
        end

        private

        def calc_checksum(value)
          Digest::MD5.hexdigest(value)
        end
      end
    end
  end
end
