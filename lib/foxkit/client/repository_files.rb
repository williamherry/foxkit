module Foxkit
  class Client

    # Methods for the RepositoryFiles API
    #
    # @see http://doc.gitlab.com/ce/api/repository_files.html
    module RepositoryFiles

      # Allows you to receive information about file in repository like name,
      # size, content. Note that file content is Base64 encoded.
      #
      # @param project_id [Integer] The ID of a project
      # @return [Array<Sawyer::Resource>] List of files
      def repository_files(project_id, options = {})
        paginate "/projects/#{project_id}/repository/files", options
      end

      # Create new file in repository
      #
      # @param project_id [Integer] The ID of a project
      # @option options [String] :file_path Full path to new file. Ex. lib/class.rb
      # @option options [String] :branch_name The name of branch
      # @option options [String] :encoding 'text' or 'base64'. Text is default.
      # @option options [String] :content File content
      # @option options [String] :commit_message Commit message
      # @return [Sawyer::Resource] basic info of newly created file
      def create_repository_file(project_id, options = {})
        post "/projects/#{project_id}/repository/files", options
      end


      # Update file in repository
      #
      # @param project_id [Integer] The ID of a project
      # @option options [String] :file_path Full path to new file. Ex. lib/class.rb
      # @option options [String] :branch_name The name of branch
      # @option options [String] :encoding 'text' or 'base64'. Text is default.
      # @option options [String] :content File content
      # @option options [String] :commit_message Commit message
      # @return [Sawyer::Resource] basic info of newly created file
      def update_repository_file(project_id, options = {})
        put "/projects/#{project_id}/repository/files", options
      end

      # Delete file from repository
      #
      # @param project_id [Integer] The ID of a project
      # @option options [String] :file_path Full path to new file. Ex. lib/class.rb
      # @option options [String] :branch_name The name of branch
      # @option options [String] :commit_message Commit message
      # @return [Sawyer::Resource] basic info of deleted file
      def delete_repository_file(project_id, options = {})
        delete "/projects/#{project_id}/repository/files", options
      end
    end
  end
end
