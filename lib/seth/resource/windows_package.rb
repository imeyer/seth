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

require 'seth/resource/package'
require 'seth/provider/package/windows'
require 'seth/win32/error' if RUBY_PLATFORM =~ /mswin|mingw|windows/

class Seth
  class Resource
    class WindowsPackage < Seth::Resource::Package

      provides :package, :on_platforms => ["windows"]

      def initialize(name, run_context=nil)
        super
        @allowed_actions = [ :install, :remove ]
        @provider = Seth::Provider::Package::Windows
        @resource_name = :windows_package
        @source ||= source(@package_name)

        # Unique to this resource
        @installer_type = nil
        @timeout = 600
        # In the past we accepted return code 127 for an unknown reason and 42 because of a bug
        @returns = [ 0 ]
      end

      def installer_type(arg=nil)
        set_or_return(
          :installer_type,
          arg,
          :kind_of => [ String ]
        )
      end

      def timeout(arg=nil)
        set_or_return(
          :timeout,
          arg,
          :kind_of => [ String, Integer ]
        )
      end

      def returns(arg=nil)
        set_or_return(
          :returns,
          arg,
          :kind_of => [ String, Integer, Array ]
        )
      end

      def source(arg=nil)
        if arg == nil && self.instance_variable_defined?(:@source) == true
          @source
        else
          raise ArgumentError, "Bad type for WindowsPackage resource, use a String" unless arg.is_a?(String)
          Seth::Log.debug("#{package_name}: sanitizing source path '#{arg}'")
          @source = ::File.absolute_path(arg).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
        end
      end
    end
  end
end

