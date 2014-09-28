module Foxkit
  class Client

    # Methods for Login
    #
    # @see http://doc.gitlab.com/ce/api/session.html
    module Sessions

      # Login with username(email) and password
      # @param login [String] The login of user
      # @param email [String] The email of user
      # @params password [String] Valid password
      def authenticate(options = {})
        post "/session", options
      end
    end
  end
end
