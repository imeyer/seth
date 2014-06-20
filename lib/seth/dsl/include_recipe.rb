#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008, 2009 Opscode, Inc.
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

require 'seth/log'

class Seth
  module DSL
    module IncludeRecipe

      def include_recipe(*recipe_names)
        run_context.include_recipe(*recipe_names)
      end

      def load_recipe(recipe_name)
        run_context.load_recipe(recipe_name)
      end

      def require_recipe(*args)
        Seth::Log.warn("require_recipe is deprecated and will be removed in a future release, please use include_recipe")
        include_recipe(*args)
      end

    end
  end
end

# **DEPRECATED**
# This used to be part of seth/mixin/language_include_recipe. Load the file to activate the deprecation code.
require 'seth/mixin/language_include_recipe'
