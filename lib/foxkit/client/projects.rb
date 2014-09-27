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

      # Get projects accessible by user
      #
      # @param archived [Boolean] If passed, limit by archived status
      # @return [Array<Sawyer::Resource>] List of projects
      def projects(options = {})
        paginate "/projects", options
      end

      # Get projects owned by user
      #
      # @return [Array<Sawyer::Resource>] List of projects
      def owned_projects(options = {})
        paginate "/projects/owned", options
      end

      # Get all projects (admin only)
      #
      # @return [Array<Sawyer::Resource>] List of projects
      def all_projects(options = {})
        paginate "/projects/all", options
      end

      # Get a single project
      #
      # @param id [Integer] The ID of a project
      # @return [Sawyer::Resource] Project information
      def project(project, options = {})
        get Project.path(project), options
      end

      # Get the events for the specified project.
      # Sorted from newest to latest
      # @param id [Integer] The ID of a project
      # @return [Array<Sawyer::Resource>] List of events
      def project_events(project, options = {})
        paginate "#{Project.path(project)}/events", options
      end

      # Creates a new project owned by the authenticated user.
      #
      # @param name [String] New project name
      # @option options [String] :path custom repository name for new project. By default generated based on name
      # @option options [String] :namespace_id namespace for the new project (defaults to user)
      # @option options [String] :description short project description
      # @option options [String] :issues_enabled `true` enables issues for this repo, `false` disables issues.
      # @option options [String] :merge_requests_enabled `true` enables merge request, `false` disables merge request
      # @option options [String] :wiki_enabled `true` enables wiki, `false` disables wiki.
      # @option options [String] :snippets_enabled `true` enables snippet, `false` disables snippet.
      # @option options [String] :public if `true` same as setting visibility_level = 20.
      # @option options [Integer] :visibility_level
      # @option options [String] :import_url
      # @return [Sawyer::Resource] Project info for the new project
      # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/projects.md
      def create_project(name, options = {})
        post '/projects', options.merge(name: name)
      end

      # Creates a new project owned by the specified user. Available only for admins.
      #
      # @param name [String] New project name
      # @param user_id [Integer] user_id of owner
      # @option options [String] :path custom repository name for new project. By default generated based on name
      # @option options [String] :namespace_id namespace for the new project (defaults to user)
      # @option options [String] :description short project description
      # @option options [String] :issues_enabled `true` enables issues for this repo, `false` disables issues.
      # @option options [String] :merge_requests_enabled `true` enables merge request, `false` disables merge request
      # @option options [String] :wiki_enabled `true` enables wiki, `false` disables wiki.
      # @option options [String] :snippets_enabled `true` enables snippet, `false` disables snippet.
      # @option options [String] :public if `true` same as setting visibility_level = 20.
      # @option options [Integer] :visibility_level
      # @option options [String] :import_url
      # @return [Sawyer::Resource] Project info for the new project
      # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/projects.md
      def create_user_project(name, user_id, options = {})
        post '/projects/user/#{user_id}', options.merge(name: name, user_id: user_id)
      end


      # Removes a project including all associated resources (issues, merge requests etc.)
      #
      # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/projects.md
      # @param project [Integer, String, Hash, Repository] A GitLab project
      # @return [Boolean] `true` if project was deleted
      def delete_project(project, options = {})
        boolean_from_response :delete, Project.path(project), options
      end

      # Get a list of a project's team members.
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @option options [string] :query Query string to search for members
      # @return [Sawyer::Resource] members of a project
      def project_members(project, options = {})
        paginate "#{Project.path(project)}/members", options
      end

      # Gets a project team member.
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param user_id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @return [Sawyer::Resource] members of a project
      def project_member(project, user_id, options = {})
        paginate "#{Project.path(project)}/members/#{user_id}", options
      end

      # Add project team member
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param user_id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param access_level [Integer] Project access level
      # @return [Sawyer::Resource] members of a project
      def add_project_member(project, user_id, options = {})
        post "#{Project.path(project)}/members", options.merge(user_id: user_id)
      end

      # Edit project team member
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param user_id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param access_level [Integer] Project access level
      # @return [Sawyer::Resource] members of a project
      def edit_project_member(project, user_id, options = {})
        put "#{Project.path(project)}/members/#{user_id}", options
      end

      # Delete project team member
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param user_id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @return [Sawyer::Resource] members of a project
      def delete_project_member(project, user_id, options = {})
        delete "#{Project.path(project)}/members/#{user_id}", options
      end

      # Get a list of a project's hooks.
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @return [Sawyer::Resource] hooks of a project
      def project_hooks(project, options = {})
        paginate "#{Project.path(project)}/hooks", options
      end

      # Gets a project hook.
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param hook_id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @return [Sawyer::Resource] hooks of a project
      def project_hook(project, hook_id, options = {})
        paginate "#{Project.path(project)}/hooks/#{hook_id}", options
      end

      # Add project hook
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param hook_id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @return [Sawyer::Resource] hooks of a project
      def add_project_hook(project, hook_id, options = {})
        post "#{Project.path(project)}/hooks", options.merge(hook_id: hook_id)
      end

      # Edit project hook
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param hook_id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @return [Sawyer::Resource] hooks of a project
      def edit_project_hook(project, hook_id, options = {})
        put "#{Project.path(project)}/hooks/#{hook_id}", options
      end

      # Delete project hook
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param hook_id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @return [Sawyer::Resource] hooks of a project
      def delete_project_hook(project, hook_id, options = {})
        delete "#{Project.path(project)}/hooks/#{hook_id}", options
      end

      # Lists all branches of a project.
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @return [Array<Sawyer::Resource>] branches of a project
      def project_branches(project, options = {})
        paginate "#{Project.path(project)}/repository/branches", options
      end

      # Lists a specific branch of a project.
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param branch [String] Branch name
      # @return [Sawyer::Resource] one branch of a project
      def project_branch(project, branch, options = {})
        get "#{Project.path(project)}/repository/branches/#{branch}", options
      end

      # Protects a single branch of a project.
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param branch [String] Branch name
      # @return [Sawyer::Resource] one branch of a project
      def protect_project_branch(project, branch, options = {})
        put "#{Project.path(project)}/repository/branches/#{branch}/protect", options
      end

      # Unprotects a single branch of a project.
      # 
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param branch [String] Branch name
      # @return [Sawyer::Resource] one branch of a project
      def unprotect_project_branch(project, branch, options = {})
        put "#{Project.path(project)}/repository/branches/#{branch}/unprotect", options
      end

      # Create a forked from/to relation between existing projects.
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      # @param forked_from_id [Integer] The ID of the project that was forked from
      def add_forked_from_project(project, forked_from_id, options = {}) 
        post "#{Project.path(project)}/fork/#{forked_from_id}", options
      end

      # Delete an existing forked from relationship
      #
      # @param id [Integer] The ID or NAMESPACE/PROJECT_NAME of a project
      def delete_forked_from_project(project, options = {})
        delete "#{Project.path(project)}/fork", options
      end

      # Search for projects by name
      #
      # @param query [String] A string contained in the project name
      # @param page [Integer] The page to retrieve
      # @param per_page [Integer] Number of projects to return per page
      def search_project(query, options = {})
        paginate "/projects/search/#{query}", options
      end
    end
  end
end
