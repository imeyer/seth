#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

describe Seth::Resource::Directory do
  include_context Seth::Resource::Directory

  let(:directory_base) { "directory_spec" }

  let(:default_mode) { ((0100777 - File.umask) & 07777).to_s(8) }

  def create_resource
    events = Seth::EventDispatch::Dispatcher.new
    node = Seth::Node.new
    run_context = Seth::RunContext.new(node, {}, events)
    Seth::Resource::Directory.new(path, run_context)
  end

  let(:resource) do
  	create_resource
  end

  it_behaves_like "a directory resource"

  it_behaves_like "a securable resource with reporting"

end
