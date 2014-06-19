#
# Author:: Klaas Jan Wierenga (<k.j.wierenga@gmail.com>)
# Copyright:: Copyright (c) 2014 Seth Software, Inc.
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

require 'spec_helper'

describe Seth::HTTP::HTTPRequest do

  context "with HTTP url scheme" do

    it "should not include port 80 in Host header" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('http://dummy.com'), '')

      request.headers['Host'].should eql('dummy.com')
    end

    it "should not include explicit port 80 in Host header" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('http://dummy.com:80'), '')

      request.headers['Host'].should eql('dummy.com')
    end

    it "should include explicit port 8000 in Host header" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('http://dummy.com:8000'), '')

      request.headers['Host'].should eql('dummy.com:8000')
    end

    it "should include explicit 443 port in Host header" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('http://dummy.com:443'), '')

      request.headers['Host'].should eql('dummy.com:443')
    end

    it "should pass on explicit Host header unchanged" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('http://dummy.com:8000'), '', { 'Host' => 'yourhost.com:8888' })

      request.headers['Host'].should eql('yourhost.com:8888')
    end

  end

  context "with HTTPS url scheme" do

    it "should not include port 443 in Host header" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('https://dummy.com'), '')

      request.headers['Host'].should eql('dummy.com')
    end

    it "should include explicit port 80 in Host header" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('https://dummy.com:80'), '')

      request.headers['Host'].should eql('dummy.com:80')
    end

    it "should include explicit port 8000 in Host header" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('https://dummy.com:8000'), '')

      request.headers['Host'].should eql('dummy.com:8000')
    end

    it "should not include explicit port 443 in Host header" do
      request = Seth::HTTP::HTTPRequest.new(:GET, URI('https://dummy.com:443'), '')

      request.headers['Host'].should eql('dummy.com')
    end

  end

  it "should pass on explicit Host header unchanged" do
    request = Seth::HTTP::HTTPRequest.new(:GET, URI('http://dummy.com:8000'), '', { 'Host' => 'myhost.com:80' })

    request.headers['Host'].should eql('myhost.com:80')
  end

end
