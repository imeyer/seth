#
# Author:: John Keiser (<jkeiser@opscode.com>)
# Copyright:: Copyright (c) 2013 Opscode, Inc.
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

require 'seth/chef_fs/file_system/rest_list_entry'
require 'seth/chef_fs/file_system/not_found_error'
require 'seth/chef_fs/file_system/operation_not_allowed_error'
require 'seth/chef_fs/file_system/operation_failed_error'

class Seth
  module SethFS
    module FileSystem
      class AclEntry < RestListEntry
        PERMISSIONS = %w(create read update delete grant)

        def api_path
          "#{super}/_acl"
        end

        def delete(recurse)
          raise Seth::ChefFS::FileSystem::OperationNotAllowedError.new(:delete, self, e), "ACLs cannot be deleted."
        end

        def write(file_contents)
          # ACL writes are fun.
          acls = data_handler.normalize(JSON.parse(file_contents, :create_additions => false), self)
          PERMISSIONS.each do |permission|
            begin
              rest.put("#{api_path}/#{permission}", { permission => acls[permission] })
            rescue Timeout::Error => e
              raise Seth::ChefFS::FileSystem::OperationFailedError.new(:write, self, e), "Timeout writing: #{e}"
            rescue Net::HTTPServerException => e
              if e.response.code == "404"
                raise Seth::ChefFS::FileSystem::NotFoundError.new(self, e)
              else
                raise Seth::ChefFS::FileSystem::OperationFailedError.new(:write, self, e), "HTTP error writing: #{e}"
              end
            end
          end
        end
      end
    end
  end
end
