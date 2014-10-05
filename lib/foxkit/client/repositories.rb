module Foxkit
  class Client

    # Methods for the Repositories API
    #
    # @see http://doc.gitlab.com/ce/api/repositories.html
    module Repositories

      # Get a list of repository tags from a project,
      # sorted by name in reverse alphabetical order.
      #
      # @param project_id [Integer] The ID of a project
      # @return [Array<Sawyer::Resource>] List of tags
      def repository_tags(project_id, options = {})
        paginate "/projects/#{project_id}/repository/tags", options
      end

      # Creates new tag in the repository that points to the supplied ref
      #
      # @param project_id [Integer] The ID of a project
      # @options option [String] :tag_name The nam eof tag
      # @options option [String] :ref Create tag using commit SHA, another tag name, or branch name
      # @options option [String] :message Creates annotated tag
      def create_repository_tag(project_id, options = {})
        post "/projects/#{project_id}/repository/tags", options
      end

      # Get a list of repository files and directories in a project.
      #
      # @param project_id [Integer] The ID of a project
      # @return [Array<Sawyer::Resource>] List of files and directories
      def repository_tree(project_id, options = {})
        paginate "/projects/#{project_id}/repository/tree", options
      end

      # Get the raw file contents for a file by commit SHA and path.
      #
      # @param project_id [Integer] The ID of a project
      # @param sha [Integer] The commit or branch name
      # @param filepath [Integer] The path the file
      # @return [Array<Sawyer::Resource>] content of file
      def repository_raw_file_content(project_id, sha, filepath, options = {})
        options.merge!(filepath: filepath)
        get "/projects/#{project_id}/repository/blobs/#{sha}", options
      end

      # Get the raw file contents for a blob by blob SHA.
      #
      # @param project_id [Integer] The ID of a project
      # @param sha [Integer] The commit or branch name
      # @return [Array<Sawyer::Resource>] content of file
      def repository_raw_blob_content(project_id, sha, options = {})
        get "/projects/#{project_id}/repository/raw_blobs/#{sha}", options
      end

      # Get an archive of the repository
      #
      # @param project_id [Integer] The ID of a project
      # @return [Array<Sawyer::Resource>] archive of a project
      def repository_archive(project_id, options = {})
        get "/projects/#{project_id}/repository/archive", options
      end

      # Compare branches, tags or commits
      #
      # @param project_id [Integer] The ID of a project
      # @param from [String] The commit SHA or branch name
      # @param to [String] The commit SHA or branch name
      # @return [Array<Sawyer::Resource>] archive of a project
      def repository_diff_between(project_id, options = {})
        get "/projects/#{project_id}/repository/compare", options
      end

      # Get repository contributors list
      #
      # @param project_id [Integer] The ID of a project
      # @return [Array<Sawyer::Resource>] archive of a project
      def repository_contributors(project_id, options = {})
        get "/projects/#{project_id}/repository/contributors", options
      end
    end
  end
end
