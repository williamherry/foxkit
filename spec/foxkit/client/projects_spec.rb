require 'spec_helper'

describe Foxkit::Client::Projects do
  before do
    Foxkit.reset!
    @client = token_auth_client
  end

  describe ".project", :vcr do
    it "returns the matching project" do
      project = @client.project(92029)
      expect(project.name).to eq("test")
      assert_requested :get, gitlab_url("api/v3/projects/92029")
    end
  end # .project
end
