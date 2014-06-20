#
# Author:: Ryan Davis (<ryand-ruby@zenspider.com>)
# Author:: Daniel DeLeo (<dan@opscode.com>)
# Author:: Nuo Yan (<nuo@opscode.com>)
# Copyright:: Copyright (c) 2011 Ryan Davis and Opscode, Inc.
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
    class TagCreate < Knife

      deps do
        require 'seth/node'
      end

      banner "knife tag create NODE TAG ..."

      def run
        name = @name_args[0]
        tags = @name_args[1..-1]

        if name.nil? || tags.nil? || tags.empty?
          show_usage
          ui.fatal("You must specify a node name and at least one tag.")
          exit 1
        end

        node = Seth::Node.load name
        tags.each do |tag|
          (node.tags << tag).uniq!
        end
        node.save
        ui.info("Created tags #{tags.join(", ")} for node #{name}.")
      end
    end
  end
end