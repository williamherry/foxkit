module Foxkit

  # Configuration options for {Client}, defaulting to values in {Default}
  module Configurable
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests.
    # @!attribute auto_paginate
    #   @return [Boolean] Auto fetch next page of results until rate limit reached
    # @!attribute connection_options
    #   @see https://github.cim/lostisland/faraday
    #   @return [Hash] Configure connection options for Faraday
    # @!attribute login
    #   @return [String] GitLab username for Basic Authentication
    # @!attribute middleware
    #   @see https://github.com/lostisland/faraday
    #   @return [Faraday::Builder or Faraday::RackBuilder] Configure middleware for Faraday
    # @!attribute netrc
    #   @return [Boolean] Instruct Foxkit to get credentials from .netrc file
    # @!attribute netrc_file
    #   @return [String] Path to .netrc file. default: ~/.netrc
    # @!attribute [w] password
    #   @return [String] GitLab password for Basic Authentication
    # @!attribute per_page
    #   @return [String] Configure page size for paginated results. API default: 30
    # @!attribute proxy
    #   @see https://github.com/lostisland/faraday
    #   @return [String] URI for proxy server
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.

    attr_accessor :auto_paginate, :connection_options, :middleware,
                  :netrc, :netrc_file, :per_page, :proxy, :user_agent
    attr_writer :password, :api_endpoint, :login

    class << self

      # List of configurable keys for {Foxkit::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :api_endpoint,
          :auto_paginate,
          :connection_options,
          :login,
          :middleware,
          :netrc,
          :netrc_file,
          :per_page,
          :password,
          :proxy,
          :user_agent
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Foxkit::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Foxkit::Default.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    def login
      @login ||= begin
                   user.login if token_authenticated?
                 end
    end

    def netrc?
      !!@netrc
    end

    private

    def options
      Hash[Foxkit::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end
