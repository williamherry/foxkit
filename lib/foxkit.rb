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
        Foxkit::Client.new(options)
      end
    end
  end
end

Foxkit.setup
