require 'seth/chef_fs/knife'

class Seth
  class Knife
    class Diff < Seth::ChefFS::Knife
      banner "knife diff PATTERNS"

      category "path-based"

      deps do
        require 'seth/chef_fs/command_line'
      end

      option :recurse,
        :long => '--[no-]recurse',
        :boolean => true,
        :default => true,
        :description => "List directories recursively."

      option :name_only,
        :long => '--name-only',
        :boolean => true,
        :description => "Only show names of modified files."

      option :name_status,
        :long => '--name-status',
        :boolean => true,
        :description => "Only show names and statuses of modified files: Added, Deleted, Modified, and Type Changed."

      option :diff_filter,
        :long => '--diff-filter=[(A|D|M|T)...[*]]',
        :description => "Select only files that are Added (A), Deleted (D), Modified (M), or have their type (i.e. regular file, directory) changed (T). Any combination of the filter characters (including none) can be used. When * (All-or-none) is added to the combination, all paths are selected if
           there is any file that matches other criteria in the comparison; if there is no file that matches other criteria, nothing is selected."

      option :cookbook_version,
        :long => '--cookbook-version VERSION',
        :description => 'Version of cookbook to download (if there are multiple versions and cookbook_versions is false)'

      def run
        if config[:name_only]
          output_mode = :name_only
        end
        if config[:name_status]
          output_mode = :name_status
        end
        patterns = pattern_args_from(name_args.length > 0 ? name_args : [ "" ])

        # Get the matches (recursively)
        error = false
        begin
          patterns.each do |pattern|
            found_error = Seth::ChefFS::CommandLine.diff_print(pattern, seth_fs, local_fs, config[:recurse] ? nil : 1, output_mode, proc { |entry| format_path(entry) }, config[:diff_filter], ui ) do |diff|
              stdout.print diff
            end
            error = true if found_error
          end
        rescue Seth::ChefFS::FileSystem::OperationFailedError => e
          ui.error "Failed on #{format_path(e.entry)} in #{e.operation}: #{e.message}"
          error = true
        end

        if error
          exit 1
        end
      end
    end
  end
end

