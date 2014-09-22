require 'netrc'

module Foxkit

  # Authentication methods from {Foxkit::Client}
  module Authentication

    # Indicates if the client was supplied Basic Auth
    # username and password
    #
    # @return [Boolean]
    def basic_authenticated?
      !!(@login && @password)
    end

    # Indicates if the client was supplied Private Token Auth
    # private_token
    #
    # @return [Boolean]
    def token_authenticated?
      @private_token
    end

    def authenticated?
      token_authenticated? || basic_authenticated?
    end

    private

    def login_from_netrc
      return unless netrc?

      info = Netrc.read netrc_file
      netrc_host = URI.parse(api_endpoint).host
      creds = info[netrc_host]
      if creds.nil?
        # creds will be nil if there is no netrc for this end point
        foxkit_warn "Error loading credentials from netrc file for #{api_endpoint}"
      else
        self.login = creds.shift
        self.password = creds.shift
      end
    rescue LoadError
      foxkit_warn "Please install netrc gem for .netrc support"
    end

  end
end
