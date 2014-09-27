require "foxkit"
require "rspec"
require 'webmock/rspec'
require 'pry'
require 'support/vcr'

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def gitlab_url(url)
  return url if url =~ /^http/

  url = gitlab_path(url)
  url = File.join(Foxkit.api_endpoint, url)
  uri = Addressable::URI.parse(url)

  uri.to_s
end

def gitlab_path(path)
  return path if path.include?('api')
  'api/' + Foxkit.api_version + path
end

def stub_delete(url)
  stub_request(:delete, gitlab_url(url))
end

def stub_get(url)
  stub_request(:get, gitlab_url(url))
end

def stub_head(url)
  stub_request(:head, gitlab_url(url))
end

def stub_patch(url)
  stub_request(:patch, gitlab_url(url))
end

def stub_post(url)
  stub_request(:post, gitlab_url(url))
end

def stub_put(url)
  stub_request(:put, gitlab_url(url))
end

def token_auth_client
  Foxkit::Client.new(:private_token => "6FpzmcU5A1FXgTWMXyMA")
end
