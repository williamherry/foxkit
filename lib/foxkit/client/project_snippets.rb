module Foxkit
  class Client
    # Methods for the Project API
    #
    # @see http://doc.gitlab.com/ce/api/project_snippets.html
    module ProjectSnippets

      # Get all project snippets
      #
      # @param project_id [Integer] ID of project
      # @return [Array<Sawyer::Resource>] List of projects
      def project_snippets(project_id, options = {})
        paginate "/projects/#{project_id}/snippets", options
      end

      # Get one specific project snippet
      #
      # @param project_id [Integer] ID of project
      # @param snippet_id [Integer] ID of snippet
      #
      # @return [Array<Sawyer::Resource>] List of projects
      def project_snippet(project_id, snippet_id, options = {})
        paginate "/projects/#{project_id}/snippets/#{snippet_id}", options
      end

      # Creates a new project snippet.
      #
      # @param project_id [Integer] ID of project
      # @option options [String] :title Title of snippet
      # @option options [String] :file_name File name of snippet
      # @option options [String] :code Content of snippet
      #
      # @return [Sawyer::Resource] info of snippet
      def create_project_snippet(project_id, options = {})
        post "/projects/#{project_id}/snippets", options
      end

      # Updates a project snippet.
      #
      # @param project_id [Integer] ID of project
      # @option options [String] :title Title of snippet
      # @option options [String] :file_name File name of snippet
      # @option options [String] :code Content of snippet
      #
      # @return [Sawyer::Resource] info of snippet
      def update_project_snippet(project_id, snippet_id, options = {})
        put "/projects/#{project_id}/snippets/#{snippet_id}", options
      end

      # Delete a new project snippet.
      #
      # @param project_id [Integer] ID of project
      # @param snippet_id [Integer] ID of snippet
      #
      # @return [Sawyer::Resource] info of snippet
      def delete_project_snippet(project_id, snippet_id, options = {})
        delete "/projects/#{project_id}/snippets/#{snippet_id}", options
      end

      # Content of a snippet
      # @param project_id [Integer] ID of project
      # @param snippet_id [Integer] ID of snippet
      #
      # @return [Sawyer::Resource] content of snippet
      def project_snippet_content(project_id, snippet_id, options = {})
        get "/projects/#{project_id}/snippets/#{snippet_id}/raw", options
      end
    end
  end
end
