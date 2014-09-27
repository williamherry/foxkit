module Foxkit
  class Client
    # Methods for the Users API
    #
    # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/users.md
    module Users

      # List all GitLab users
      #
      # This provides a dump of every user, in the order that they signed up
      # for GitLab.
      #
      # Return more info if authed user is Admin.
      #
      # @return [Array<Sawyer::Resource>] List of GitHub users.
      def all_users(options = {})
        paginate "/users", options
      end

      # Get a single user
      #
      # Return more info if authed user is Admin.
      #
      # @param user [Integer, String] GitLab user login or id.
      # @return [Sawyer::Resource]
      # @example
      #   Foxkit.user("sferik")
      # @return [Sawyer::Resource] User info
      def user(user=nil, options = {})
        get User.path(user), options
      end

      # Create a user (only for Admin)
      #
      # @param options [Hash] A customizable set of options.
      # @option options [String] :email - Email
      # @option options [String] :password - Password
      # @option options [String] :username - Username
      # @option options [String] :name - Name
      # @option options [String] :skype Skype ID
      # @option options [String] :linkedin LinkedIn
      # @option options [String] :twitter Twitter account
      # @option optinos [String] :website_url Website URL
      # @option options [String] :projects_limit Number of projects user can create
      # @option options [String] :extern_uid External UID
      # @option options [String] :provider External provider name
      # @option optinos [String] :bio User's biography
      # @option options [Boolean] :admin User is admin - true or false (default)
      # @option options [Boolean] :can_create_group User can create groups - true or false
      # @return [Sawyer::Resource] User info
      def create_user(options = {})
        post "/users", options
      end

      # Update a user (only for Admin)
      #
      # @param options [Hash] A customizable set of options.
      # @option options [String] :email - Email
      # @option options [String] :password - Password
      # @option options [String] :username - Username
      # @option options [String] :name - Name
      # @option options [String] :skype Skype ID
      # @option options [String] :linkedin LinkedIn
      # @option options [String] :twitter Twitter account
      # @option optinos [String] :website_url Website URL
      # @option options [String] :projects_limit Number of projects user can create
      # @option options [String] :extern_uid External UID
      # @option options [String] :provider External provider name
      # @option optinos [String] :bio User's biography
      # @option options [Boolean] :admin User is admin - true or false (default)
      # @option options [Boolean] :can_create_group User can create groups - true or false
      # @return [Sawyer::Resource] User info
      def update_user(user, options = {})
        put "/users/#{user}", options
      end

      # Delete a user (only for Admin)
      #
      # @param user [Integer] ID of user
      # @return [Boolean] `true` if user was deleted
      def delete_user(user, options = {})
        boolean_from_response :delete, "/users/#{user}", options
      end

      # List SSH keys for user
      #
      # List authenticated user's keys if no user pass
      # List given user's keys if pass user (only for Admin)
      #
      # @param user [Integer] ID of user
      # @return [Array<Sawyer::Resource>] List of keys
      def user_keys(user = nil, options = {})
        paginate "#{User.path(user)}/keys", options
      end

      # Get a single key.
      #
      # @param key_id [Integer] The ID of an SSH key
      # @return [Sawyer::Resource] Key detail
      def key(key_id, options = {})
        get "/user/keys/#{key_id}", options
      end

      # Add SSH key for authenticated user
      #
      # @option options [String] :title New SSH Key's title
      # @option options [String] :key New SSH key
      # @return [Sawyer::Resource] Key detail
      def add_key(options = {})
        post "/user/keys", options
      end

      # Add SSH key for given user
      #
      # @param user [Integer] ID of user
      # @option options [String] :title New SSH Key's title
      # @option options [String] :key New SSH key
      # @return [Sawyer::Resource] Key detail
      def add_user_key(user, options = {})
        post "#{User.path(user)}/keys", options
      end

      # Delete key of authenticated user
      #
      # @param key_id [Integer] ID of key to delete
      # @return [Boolean] `true` if key was deleted
      def delete_key(key_id, options = {})
        boolean_from_response :delete, "/user/keys/#{key_id}", options
      end

      # Delete a given user's key
      #
      # @param user [Integer] ID of user
      # @param key_id [Integer] ID of key
      # @return [Boolean] `true` if key was deleted
      def delete_user_key(user, key_id, options = {})
        boolean_from_response :delete, "/users/#{user}/keys/#{key_id}", options
      end
    end
  end
end
