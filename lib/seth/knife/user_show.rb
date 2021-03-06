#
# Author:: Steven Danna (<steve@opscode.com>)
# Copyright:: Copyright (c) 2009 Opscode, Inc.
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

require 'seth/knife'

class Seth
  class Knife
    class UserShow < Knife

      include Knife::Core::MultiAttributeReturnOption

      deps do
        require 'seth/user'
        require 'seth/json_compat'
      end

      banner "knife user show USER (options)"

      def run
        @user_name = @name_args[0]

        if @user_name.nil?
          show_usage
          ui.fatal("You must specify a user name")
          exit 1
        end

        user = Seth::User.load(@user_name)
        output(format_for_display(user))
      end

    end
  end
end
