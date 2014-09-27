require "spec_helper"

describe Foxkit::Client do

  describe "module configuration" do

    before do
      Foxkit.reset!
      Foxkit.configure do |config|
        Foxkit::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Foxkit.reset!
    end

    it "inherits the module configuration" do
      client = Foxkit::Client.new
      Foxkit::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
          :per_page => 40,
          :login    => "william",
          :password => "il0veruby"
        }
      end

      it "overrides module configuration" do
        client = Foxkit::Client.new(@opts)
        expect(client.per_page).to eq(40)
        expect(client.login).to eq("william")
        expect(client.instance_variable_get(:"@password")).to eq("il0veruby")
        expect(client.auto_paginate).to eq(Foxkit.auto_paginate)
      end

      it "can set configuration after initialization" do
        client = Foxkit::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.per_page).to eq(40)
        expect(client.login).to eq("william")
        expect(client.instance_variable_get(:"@password")).to eq("il0veruby")
        expect(client.auto_paginate).to eq(Foxkit.auto_paginate)
      end

      it "masks passwords on inspect" do
        client = Foxkit::Client.new(@opts)
        inspected = client.inspect
        expect(inspected).not_to include("il0veruby")
      end

      describe "with .netrc" do
        before do
          File.chmod(0600, File.join(fixture_path, ".netrc"))
        end

        it "can read .netrc files" do
          Foxkit.reset!
          client = Foxkit::Client.new(:netrc => true, :netrc_file => File.join(fixture_path, ".netrc"))
          expect(client.login).to eq("william")
          expect(client.instance_variable_get(:"@password")).to eq("il0veruby")
        end

        it "can read non-standard API endpoint creds from .netrc" do
          Foxkit.reset!
          client = Foxkit::Client.new(:netrc => true, :netrc_file => File.join(fixture_path, '.netrc'), :api_endpoint => 'http://gitlab.dev')
          expect(client.login).to eq("defunkt")
          expect(client.instance_variable_get(:"@password")).to eq("il0veruby")
        end
      end
    end
  end

  describe "authentication" do
    before do
      Foxkit.reset!
      @client = Foxkit.client
    end

    describe "with module level config" do
      before do
        Foxkit.reset!
      end

      it "sets basic auth creds with .configure" do
        Foxkit.configure do |config|
          config.login = "william"
          config.password = "il0veruby"
        end
        expect(Foxkit.client).to be_basic_authenticated
      end

      it "sets basic auth creds with module methods" do
        Foxkit.login = 'william'
        Foxkit.password = 'il0veruby'
        expect(Foxkit.client).to be_basic_authenticated
      end
    end

    describe "with class level config" do
      it "sets basic auth creds with .configure" do
        @client.configure do |config|
          config.login = "william"
          config.password = "il0veruby"
        end
        expect(@client).to be_basic_authenticated
      end

      it "sets basic auth creds with instance methods" do
        @client.login = 'william'
        @client.password = 'il0veruby'
        expect(@client).to be_basic_authenticated
      end
    end

    describe "when basic authenticated" do
      it "makes authenticated calls" do
        Foxkit.configure do |config|
          config.login = "william"
          config.password = "il0veruby"
        end

        root_request = stub_get("https://william:il0veruby@gitlab.com/api/v3/projects")
        Foxkit.client.get("/projects")
        assert_requested root_request
      end
    end
  end

  describe ".agent" do
    before do
      Foxkit.reset!
    end

    it "acts like a Sawyer agent" do
      expect(Foxkit.client.agent).to respond_to :start
    end

    it "caches the agent" do
      agent = Foxkit.client.agent
      expect(agent.object_id).to eq (Foxkit.client.agent.object_id)
    end
  end

  describe ".get", :vcr do
    before(:each) do
      Foxkit.reset!
    end
    it "handles query params" do
      Foxkit.private_token = "6FpzmcU5A1FXgTWMXyMA"
      Foxkit.get "/projects", :foo => "bar"
      assert_requested :get, "#{gitlab_url('/projects?foo=bar')}"
    end
    it "handles headers" do
      request = stub_get("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Foxkit.get "/zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .get

  describe ".head", :vcr do
    it "handles query params" do
      Foxkit.reset!
      Foxkit.private_token = "6FpzmcU5A1FXgTWMXyMA"
      Foxkit.head "/projects", :foo => "bar"
      assert_requested :head, "#{gitlab_url('/projects?foo=bar')}"
    end
    it "handles headers" do
      Foxkit.reset!
      request = stub_head("/zen").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      Foxkit.head "/zen", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .head

  describe "when making requests" do
    before do
      Foxkit.reset!
      @client = Foxkit.client
    end
    it "Accepts application/json by default" do
      VCR.use_cassette 'root' do
        root_request = stub_get("/").
          with(:headers => {:accept => "application/json"})
        @client.get "/"
        assert_requested root_request
        expect(@client.last_response.status).to eq(200)
      end
    end
    it "allows Accept'ing another media type" do
      root_request = stub_get("/").
        with(:headers => {:accept => "application/vnd.gitlab.beta.diff+json"})
      @client.get "/", :accept => "application/vnd.gitlab.beta.diff+json"
      assert_requested root_request
      expect(@client.last_response.status).to eq(200)
    end
    it "sets a default user agent" do
      root_request = stub_get("/").
        with(:headers => {:user_agent => Foxkit::Default.user_agent})
      @client.get "/"
      assert_requested root_request
      expect(@client.last_response.status).to eq(200)
    end
    it "sets a custom user agent" do
      user_agent = "Mozilla/5.0 I am Spartacus!"
      root_request = stub_get("/").
        with(:headers => {:user_agent => user_agent})
      client = Foxkit::Client.new(:user_agent => user_agent)
      client.get "/"
      assert_requested root_request
      expect(client.last_response.status).to eq(200)
    end
    it "sets a proxy server" do
      Foxkit.configure do |config|
        config.proxy = 'http://proxy.example.com:80'
      end
      conn = Foxkit.client.send(:agent).instance_variable_get(:"@conn")
      expect(conn.proxy[:uri].to_s).to eq('http://proxy.example.com')
    end
    it "passes along request headers for POST" do
      headers = {"X-GitLab-Foo" => "bar"}
      root_request = stub_post("/").
        with(:headers => headers).
        to_return(:status => 201)
      client = Foxkit::Client.new
      client.post "/", :headers => headers
      assert_requested root_request
      expect(client.last_response.status).to eq(201)
    end
  end


  describe "auto pagination", :vcr do
    before do
      Foxkit.reset!
      Foxkit.configure do |config|
        config.auto_paginate = true
        config.per_page = 1
        config.private_token = "6FpzmcU5A1FXgTWMXyMA"
      end
    end

    after do
      Foxkit.reset!
    end

    it "fetches all the pages" do
      url = '/projects?per_page=1'
      Foxkit.client.paginate url
      assert_requested :get, gitlab_url(url)
      (2..3).each do |i|
        assert_requested :get, gitlab_url("#{url}&page=#{i}")
      end
    end

    it "accepts a block for custom result concatination" do
      results = Foxkit.client.paginate("/projects",
        :per_page => 1) { |data, last_response|
        data.concat last_response.data
      }

      expect(results.size).to eq(3)
    end
  end

  context "error handling" do
    before do
      Foxkit.reset!
      VCR.turn_off!
    end

    after do
      VCR.turn_on!
    end

    it "raises on 404" do
      stub_get('/booya').to_return(:status => 404)
      expect { Foxkit.get('/booya') }.to raise_error Foxkit::NotFound
    end

    it "raises on 500" do
      stub_get('/boom').to_return(:status => 500)
      expect { Foxkit.get('/boom') }.to raise_error Foxkit::InternalServerError
    end

    it "includes a message" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "No repository found for hubtopic"}.to_json
      begin
        Foxkit.get('/boom')
      rescue Foxkit::UnprocessableEntity => e
        expect(e.message).to include("GET #{gitlab_url("/boom")}: 422 - No repository found")
      end
    end

    it "includes an error" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:error => "No repository found for hubtopic"}.to_json
      begin
        Foxkit.get('/boom')
      rescue Foxkit::UnprocessableEntity => e
        expect(e.message).to include("GET #{gitlab_url("/boom")}: 422 - Error: No repository found")
      end
    end

    it "includes an error summary" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Validation Failed",
          :errors => [
            :resource => "Issue",
            :field    => "title",
            :code     => "missing_field"
          ]
        }.to_json
      begin
        Foxkit.get('/boom')
      rescue Foxkit::UnprocessableEntity => e
        expect(e.message).to include("GET #{gitlab_url("/boom")}: 422 - Validation Failed")
        expect(e.message).to include("  resource: Issue")
        expect(e.message).to include("  field: title")
        expect(e.message).to include("  code: missing_field")
      end
    end

    it "exposes errors array" do
      stub_get('/boom').
        to_return \
        :status => 422,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Validation Failed",
          :errors => [
            :resource => "Issue",
            :field    => "title",
            :code     => "missing_field"
          ]
        }.to_json
      begin
        Foxkit.get('/boom')
      rescue Foxkit::UnprocessableEntity => e
        expect(e.errors.first[:resource]).to eq("Issue")
        expect(e.errors.first[:field]).to eq("title")
        expect(e.errors.first[:code]).to eq("missing_field")
      end
    end

    it "knows the difference between Forbidden and rate limiting" do
      stub_get('/some/admin/stuffs').to_return(:status => 403)
      expect { Foxkit.get('/some/admin/stuffs') }.to raise_error Foxkit::Forbidden

      stub_get('/users/mojomobo').to_return \
        :status => 403,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "API rate limit exceeded"}.to_json
      expect { Foxkit.get('/users/mojomobo') }.to raise_error Foxkit::TooManyRequests

      stub_get('/user').to_return \
        :status => 403,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "Maximum number of login attempts exceeded"}.to_json
      expect { Foxkit.get('/user') }.to raise_error Foxkit::TooManyLoginAttempts
    end

    it "raises on unknown client errors" do
      stub_get('/user').to_return \
        :status => 418,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "I'm a teapot"}.to_json
      expect { Foxkit.get('/user') }.to raise_error Foxkit::ClientError
    end

    it "raises on unknown server errors" do
      stub_get('/user').to_return \
        :status => 509,
        :headers => {
          :content_type => "application/json",
        },
        :body => {:message => "Bandwidth exceeded"}.to_json
      expect { Foxkit.get('/user') }.to raise_error Foxkit::ServerError
    end

    it "handles documentation URLs in error messages" do
      stub_get('/user').to_return \
        :status => 415,
        :headers => {
          :content_type => "application/json",
        },
        :body => {
          :message => "Unsupported Media Type",
          :documentation_url => "http://developer.gitlab.com/v3"
        }.to_json
      begin
        Foxkit.get('/user')
      rescue Foxkit::UnsupportedMediaType => e
        msg = "415 - Unsupported Media Type"
        expect(e.message).to include(msg)
        expect(e.documentation_url).to eq("http://developer.gitlab.com/v3")
      end
    end

    it "handles an error response with an array body" do
      stub_get('/user').to_return \
        :status => 500,
        :headers => {
          :content_type => "application/json"
        },
        :body => [].to_json
      expect { Foxkit.get('/user') }.to raise_error Foxkit::ServerError
    end
  end


end
