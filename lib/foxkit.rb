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
      @client = Foxkit::Client.new(options) unless defined?(@client) && @client.same_options?(options)
      @client
    end
  end
end

Foxkit.setup
