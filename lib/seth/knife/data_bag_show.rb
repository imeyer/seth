#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Seth Falcon (<seth@opscode.com>)
# Copyright:: Copyright (c) 2009-2010 Opscode, Inc.
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
    class DataBagShow < Knife

      deps do
        require 'seth/data_bag'
        require 'seth/encrypted_data_bag_item'
      end

      banner "knife data bag show BAG [ITEM] (options)"
      category "data bag"

      option :secret,
        :short => "-s SECRET",
        :long  => "--secret ",
        :description => "The secret key to use to decrypt data bag item values",
        :proc => Proc.new { |s| Seth::Config[:knife][:secret] = s }

      option :secret_file,
        :long => "--secret-file SECRET_FILE",
        :description => "A file containing the secret key to use to decrypt data bag item values",
        :proc => Proc.new { |sf| Seth::Config[:knife][:secret_file] = sf }

      def read_secret
        if config[:secret]
          config[:secret]
        else
          Seth::EncryptedDataBagItem.load_secret(config[:secret_file])
        end
      end

      def use_encryption
        if config[:secret] && config[:secret_file]
          stdout.puts "please specify only one of --secret, --secret-file"
          exit(1)
        end
        config[:secret] || config[:secret_file]
      end

      def run
        display = case @name_args.length
        when 2
          if use_encryption
            raw = Seth::EncryptedDataBagItem.load(@name_args[0],
                                                  @name_args[1],
                                                  read_secret)
            format_for_display(raw.to_hash)
          else
            format_for_display(Seth::DataBagItem.load(@name_args[0], @name_args[1]).raw_data)
          end
        when 1
          format_list_for_display(Seth::DataBag.load(@name_args[0]))
        else
          stdout.puts opt_parser
          exit(1)
        end
        output(display)
      end
    end
  end
end

