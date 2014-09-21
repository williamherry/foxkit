require 'netrc'

module Foxkit

  # Authentication methods from {Foxkit::Client}
  module Authentication

    # Indicates if the client was supplied  Basic Auth
    # username and password
    #
    # @return [Boolean]
    def basic_authenticated?
      !!(@login && @password)
    end

    def authenticated?
      basic_authenticated?
    end

    private

    def login_from_netrc
      return unless netrc?

      info = Netrc.read netrc_file
      netrc_host = URI.parse(api_endpoint).host
      creds = info[netrc_host]
      if creds.nil?
        # creds will be nil if there is no netrc for this end point
        octokit_warn "Error loading credentials from netrc file for #{api_endpoint}"
      else
        self.login = creds.shift
        self.password = creds.shift
      end
    rescue LoadError
      octokit_warn "Please install netrc gem for .netrc support"
    end

  end
end
