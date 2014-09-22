require 'faraday'
require 'foxkit/error'

module Foxkit
  # Faraday response middleware
  module Response

    # This class raises an Octokit-flavored exception based
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = Foxkit::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
