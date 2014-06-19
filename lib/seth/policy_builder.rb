#
# Author:: Daniel DeLeo (<dan@getseth.com>)
# Copyright:: Copyright 2008-2014 Seth Software, Inc.
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

require 'seth/policy_builder/expand_node_object'
require 'seth/policy_builder/policyfile'

class Seth

  # PolicyBuilder contains classes that handles fetching policy from server or
  # disk and resolving any indirection (e.g. expanding run_list).
  #
  # INPUTS
  # * event stream object
  # * node object/run_list
  # * json_attribs
  # * override_runlist
  #
  # OUTPUTS
  # * mutated node object (implicit)
  # * a new RunStatus (probably doesn't need to be here)
  # * cookbooks sync'd to disk
  # * cookbook_hash is stored in run_context
  module PolicyBuilder

    def self.strategy
      if Seth::Config[:use_policyfile]
        Policyfile
      else
        ExpandNodeObject
      end
    end

  end
end
