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
          client = Foxkit::Client.new(:netrc => true, :netrc_file => File.join(fixture_path, '.netrc'), :api_endpoint => 'http://api.gitlab.dev')
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

        root_request = stub_get("http://william:il0veruby@api.gitlab.com/")
        Foxkit.client.get("/")
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

end
