#
# Author:: Toomas Pelberg (<toomasp@gmx.net>)
# Copyright:: Copyright (c) 2010 Opscode, Inc.
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

require 'seth/resource/package'
require 'seth/provider/package/smartos'

class Seth
  class Resource
    class SmartosPackage < Seth::Resource::Package

      def initialize(name, run_context=nil)
        super
        @resource_name = :smartos_package
        @provider = Seth::Provider::Package::SmartOS
      end

    end
  end
end

# Backwards compatability
# @todo remove in Seth 12
Seth::Resource::SmartOSPackage = seth::Resource::SmartosPackage