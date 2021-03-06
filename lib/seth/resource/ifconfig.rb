#
# Author:: Jason K. Jackson (jasonjackson@gmail.com)
# Author:: Tyler Cloke (<tyler@opscode.com>)
# Copyright:: Copyright (c) 2009 Jason K. Jackson
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

require 'seth/resource'

class Seth
  class Resource
    class Ifconfig < Seth::Resource

      identity_attr :device

      state_attrs :inet_addr, :mask

      def initialize(name, run_context=nil)
        super
        @resource_name = :ifconfig
        @target = name
        @action = :add
        @allowed_actions.push(:add, :delete, :enable, :disable)
        @hwaddr = nil
        @mask = nil
        @inet_addr = nil
        @bcast = nil
        @mtu = nil
        @metric = nil
        @device = nil
        @onboot = nil
        @network = nil
        @bootproto = nil
        @onparent = nil
      end

      def target(arg=nil)
        set_or_return(
          :target,
          arg,
          :kind_of => String
        )
      end

      def device(arg=nil)
        set_or_return(
          :device,
          arg,
          :kind_of => String
        )
      end

      def hwaddr(arg=nil)
        set_or_return(
          :hwaddr,
          arg,
          :kind_of => String
        )
      end

      def inet_addr(arg=nil)
        set_or_return(
          :inet_addr,
          arg,
          :kind_of => String
        )
      end

      def bcast(arg=nil)
        set_or_return(
          :bcast,
          arg,
          :kind_of => String
        )
      end

      def mask(arg=nil)
        set_or_return(
          :mask,
          arg,
          :kind_of => String
        )
      end

      def mtu(arg=nil)
        set_or_return(
          :mtu,
          arg,
          :kind_of => String
        )
      end

      def metric(arg=nil)
        set_or_return(
          :metric,
          arg,
          :kind_of => String
        )
      end

      def onboot(arg=nil)
        set_or_return(
          :onboot,
          arg,
          :kind_of => String
        )
      end

      def network(arg=nil)
        set_or_return(
          :network,
          arg,
          :kind_of => String
        )
      end

      def bootproto(arg=nil)
        set_or_return(
          :bootproto,
          arg,
          :kind_of => String
        )
      end

      def onparent(arg=nil)
        set_or_return(
          :onparent,
          arg,
          :kind_of => String
        )
      end
    end

  end
end


