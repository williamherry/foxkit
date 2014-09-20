require 'faraday'
require 'foxkit/version'

module Foxkit

  # Default configuration options for [Client}
  module Default

    # Default User Agent header string
    USER_AGENT = "Foxkit Ruby Gem #{Foxkit::VERSION}".freeze

    # In Faraday 0.9, Faraday::Builder was renamed to Faraday::RackBuilder
    RACK_BUILDER_CLASS = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder

    # Default Faraday middleware stack
    MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
      builder.adapter Faraday.default_adapter
    end

    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[Foxkit::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # Default API endpoint from ENV
      # @return [String]
      def api_endpoint
        ENV['FOXKIT_API_ENDPOINT']
      end

      # Default pagination preference from ENV
      # @return [String]
      def auto_paginate
        ENV['FOXKIT_AUTO_PAGINATE']
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :user_agent => user_agent
          }
        }
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['FOXKIT_USER_AGENT'] || USER_AGENT
      end

      # Default middleware stack for Faraday::Connection
      # from {MIDDLEWARE}
      # @return [String]
      def middleware
        MIDDLEWARE
      end

      # Default GitLab username for Basic Auth from ENV
      # @return [String]
      def login
        ENV['FOXKIT_LOGIN']
      end

      # Default GitLab password for Basic Auth from ENV
      # @return [String]
      def password
        ENV['FOXKIT_PASSWORD']
      end

      # Default pagination page size from ENV
      # @return [Fixnum] Page size
      def per_page
        page_size = ENV['FOXKIT_PER_PAGE']

        page_size.to_i if page_size
      end

      # Default proxy server URI for Faraday connection from ENV
      # @return [String]
      def proxy
        ENV['FOXKIT_PROXY']
      end

      # Default behavior for reading .netrc file
      # @return [Boolean]
      def netrc
        ENV['FOXKIT_NETRC'] || false
      end

      # Default path for .netrc file
      # @return [String]
      def netrc_file
        ENV['FOXKIT_NETRC_FILE'] || File.join(ENV['HOME'].to_s, '.netrc')
      end

    end
  end
end