#
# Author:: Bryan McLellan <btm@loftninjas.org>
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

require 'seth/knife/configure'
require 'ohai'

describe "knife configure" do
  let (:ohai) do
    o = Ohai::System.new
    o.load_plugins
    o.require_plugin 'os'
    o.require_plugin 'hostname'
    o
  end

  it "loads the fqdn from Ohai" do
    knife_configure = Seth::Knife::Configure.new
    hostname_guess = ohai[:fqdn] || ohai[:machinename] || ohai[:hostname] || 'localhost'
    expect(knife_configure.guess_servername).to eql(hostname_guess)
  end
end
