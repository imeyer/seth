#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
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

describe Seth::Resource::AptPackage, "initialize" do

  before(:each) do
    @resource = Seth::Resource::AptPackage.new("foo")
  end

  it "should return a Seth::Resource::AptPackage" do
    @resource.should be_a_kind_of(Seth::Resource::AptPackage)
  end

  it "should set the resource_name to :apt_package" do
    @resource.resource_name.should eql(:apt_package)
  end

  it "should set the provider to Seth::Provider::Package::Apt" do
    @resource.provider.should eql(Seth::Provider::Package::Apt)
  end

  it "should support default_release" do
    @resource.default_release("lenny-backports")
    @resource.default_release.should eql("lenny-backports")
  end

  # String, Integer
  [ "600", 600 ].each do |val|
    it "supports setting a timeout as a #{val.class}" do
      @resource.timeout(val)
      expect(@resource.timeout).to eql(val)
    end
  end
end
