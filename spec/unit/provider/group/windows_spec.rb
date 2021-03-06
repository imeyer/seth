#
# Author:: Doug MacEachern (<dougm@vmware.com>)
# Copyright:: Copyright (c) 2010 VMware, Inc.
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

class Seth
  class Util
    class Windows
      class NetGroup
      end
    end
  end
end

describe Seth::Provider::Group::Windows do
  before do
    @node = Seth::Node.new
    @events = Seth::EventDispatch::Dispatcher.new
    @run_context = Seth::RunContext.new(@node, {}, @events)
    @new_resource = Seth::Resource::Group.new("staff")
    @net_group = double("Seth::Util::Windows::NetGroup")
    Seth::Util::Windows::NetGroup.stub(:new).and_return(@net_group)
    @provider = Seth::Provider::Group::Windows.new(@new_resource, @run_context)
  end

  describe "when creating the group" do
    it "should call @net_group.local_add" do
      @net_group.should_receive(:local_set_members).with([])
      @net_group.should_receive(:local_add)
      @provider.create_group
    end
  end

  describe "manage_group" do
    before do
      @new_resource.members([ "us" ])
      @current_resource = Seth::Resource::Group.new("staff")
      @current_resource.members [ "all", "your", "base" ]

      Seth::Util::Windows::NetGroup.stub(:new).and_return(@net_group)
      @net_group.stub(:local_add_members)
      @net_group.stub(:local_set_members)
      @provider.stub(:local_group_name_to_sid)
      @provider.current_resource = @current_resource
    end

    it "should call @net_group.local_set_members" do
      @new_resource.stub(:append).and_return(false)
      @net_group.should_receive(:local_set_members).with(@new_resource.members)
      @provider.manage_group
    end

    it "should call @net_group.local_add_members" do
      @new_resource.stub(:append).and_return(true)
      @net_group.should_receive(:local_add_members).with(@new_resource.members)
      @provider.manage_group
    end

  end

  describe "remove_group" do
    before do
      Seth::Util::Windows::NetGroup.stub(:new).and_return(@net_group)
      @provider.stub(:run_command).and_return(true)
    end

    it "should call @net_group.local_delete" do
      @net_group.should_receive(:local_delete)
      @provider.remove_group
    end
  end
end

describe Seth::Provider::Group::Windows, "NetGroup" do
  before do
    @node = Seth::Node.new
    @events = Seth::EventDispatch::Dispatcher.new
    @run_context = Seth::RunContext.new(@node, {}, @events)
    @new_resource = Seth::Resource::Group.new("Creating a new group")
    @new_resource.group_name "Remote Desktop Users"
  end
  it 'sets group_name correctly' do
    Seth::Util::Windows::NetGroup.should_receive(:new).with("Remote Desktop Users")
    Seth::Provider::Group::Windows.new(@new_resource, @run_context)
  end
end
