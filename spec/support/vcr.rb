require "json"
require "vcr"

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<GITLAB_LOGIN>") do
    test_gitlab_login
  end
  c.filter_sensitive_data("<GITLAB_PASSWORD>") do
    test_gitlab_password
  end

  c.before_http_request(:real?) do |request|
    next if request.headers['X-Vcr-Test-Repo-Setup']
    next unless request.uri.include? test_gitlab_repository

    options = {
      :headers => {'X-Vcr-Test-Repo-Setup' => 'true'},
      :auto_init => true
    }

    test_repo = "#{test_gitlab_login}/#{test_gitlab_repository}"
  end

  c.ignore_request do |request|
    !!request.headers['X-Vcr-Test-Repo-Setup']
  end

  c.default_cassette_options = {
    :serialize_with             => :json,
    # TODO: Track down UTF-8 issue and remove
    :preserve_exact_body_bytes  => true,
    :decode_compressed_response => true,
    :record                     => ENV['TRAVIS'] ? :none : :all
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def test_gitlab_login
  ENV.fetch 'FOXKIT_TEST_GITLAB_LOGIN', 'api-padawan'
end

def test_gitlab_password
  ENV.fetch 'FOXKIT_TEST_GITLAB_PASSWORD', 'wow_such_password'
end

def test_gitlab_repository
  ENV.fetch 'FOXKIT_TEST_GITLAB_REPOSITORY', 'api-sandbox'
end

def basic_gitlab_url(path, options = {})
  url = File.join(Foxkit.api_endpoint, path)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")

  uri.user = options.fetch(:login, test_gitlab_login)
  uri.password = options.fetch(:password, test_gitlab_password)

  uri.to_s
end

def basic_auth_client(login = test_gitlab_login, password = test_gitlab_password )
  client = Foxkit.client
  client.login = test_gitlab_login
  client.password = test_gitlab_password

  client
end
