require 'foxkit/client'
require 'foxkit/default'

# Ruby toolkit for the GitLab API
module Foxkit
  class << self
    include Foxkit::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [Foxkit::Client] API wrapper
    def client
      if defined?(@client) && @client.same_options?(options)
        @client
      else
        @client = Foxkit::Client.new(options)
      end
    end
    
    private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end
  end
end

Foxkit.setup
