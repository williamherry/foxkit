module Foxkit
  class Client

    # Methods for the Project API
    #
    # @see http://doc.gitlab.com/ce/api/projects.html
    module Projects

      # Check if a project exists
      #
      # @param repo [Integer, String, Hash, Repository] A GitLab project
      # @return [Sawyer::Resource] if a project exists, false otherwise
      def project?(repo, options = {})
        !!project(repo, options)
      rescue Foxkit::NotFound
        false
      end

      # Get a single project
      #
      # @param repo [Integer, String, Hash, Repository] A GitLab project
      # @return [Sawyer::Resource] Project information
      def project(project, options = {})
        get Project.path(project), options
      end
    end
  end
end
