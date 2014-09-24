require 'spec_helper'

describe Foxkit::Client::Projects do
  before do
    Foxkit.reset!
    @client = token_auth_client
  end

  describe ".projects", :vcr do
    it "returns the projects accessible by the authenticated user" do
      projects = @client.projects
      assert_requested :get, gitlab_url("api/v3/projects")
    end
  end # .projects

  describe ".owned_projects", :vcr do
    it "returns the projects owned by the authenticated user" do
      projects = @client.owned_projects
      assert_requested :get, gitlab_url("api/v3/projects/owned")
    end
  end # .owned_projects

  describe ".all_projects", :vcr do
    it "returns the all projects (admin only) " do
      expect do
        projects = @client.all_projects
      end.to raise_error Foxkit::Forbidden
    end
  end # .all_projects

  describe ".project", :vcr do
    it "returns the matching project" do
      project = @client.project(92029)
      expect(project.name).to eq("test")
      assert_requested :get, gitlab_url("api/v3/projects/92029")
    end
  end # .project

  describe ".project_events", :vcr do
    it "returns all events of a project" do
      @client.project_events(92029)
      assert_requested :get, gitlab_url("api/v3/projects/92029/events")
    end
  end

  describe ".create_project", :vcr do
    it "creates a new project owned by the authenticated user" do
      project = @client.create_project("an-project")
      expect(project.name).to eq("an-project")
      assert_requested :post, gitlab_url("/api/v3/projects")

      # cleanup
      begin
        @client.delete_project(project.id)
      rescue Foxkit::NotFound
      end
    end

    it "create a new project for user" do
      expect do
        projects = @client.create_user_project("an-project", 1)
      end.to raise_error Foxkit::Forbidden
    end      
  end

  describe ".project_members", :vcr do
    it "Get a list of a project's team members." do
      @client.project_members(92029)
      assert_requested :get, gitlab_url("/api/v3/projects/92029/members")
    end
  end

  describe ".project_member", :vcr do
    it "Return a given member of project" do
      request = stub_get gitlab_url("/api/v3/projects/92029/members/1")
      @client.project_member(92029, 1)
      assert_requested request
    end
  end

  describe ".add_project_member", :vcr do
    it "add a user to project" do
      request = stub_post gitlab_url("/api/v3/projects/92029/members")
      @client.add_project_member(92029, 1, access_level: 1)
      assert_requested request
    end
  end

  describe ".edit_project_member", :vcr do
    it "edit a user of project" do
      request = stub_put gitlab_url("/api/v3/projects/92029/members/1")
      @client.edit_project_member(92029, 1, access_level: 1)
      assert_requested request
    end
  end

  describe ".delete_project_member", :vcr do
    it "delete a user of project" do
      request = stub_delete gitlab_url("/api/v3/projects/92029/members/1")
      @client.delete_project_member(92029, 1)
      assert_requested request
    end
  end

  describe ".project_hooks", :vcr do
    it "Get a list of a project's hooks." do
      @client.project_hooks(92029)
      assert_requested :get, gitlab_url("/api/v3/projects/92029/hooks")
    end
  end

  describe ".project_hook", :vcr do
    it "Return a given hook of project" do
      request = stub_get gitlab_url("/api/v3/projects/92029/hooks/1")
      @client.project_hook(92029, 1)
      assert_requested request
    end
  end

  describe ".add_project_hook", :vcr do
    it "add a hook to project" do
      request = stub_post gitlab_url("/api/v3/projects/92029/hooks")
      @client.add_project_hook(92029, 1)
      assert_requested request
    end
  end

  
  describe ".edit_project_hook", :vcr do
    it "edit a hook of project" do
      request = stub_put gitlab_url("/api/v3/projects/92029/hooks/1")
      @client.edit_project_hook(92029, 1)
      assert_requested request
    end
  end

  describe ".delete_project_hook", :vcr do
    it "delete a hook of project" do
      request = stub_delete gitlab_url("/api/v3/projects/92029/hooks/1")
      @client.delete_project_hook(92029, 1)
      assert_requested request
    end
  end

  describe ".project_branches", :vcr do
    it "lists all branches of a project" do
      request = stub_get gitlab_url("/api/v3/projects/92029/repository/branches")
      @client.project_branches(92029)
      assert_requested request
    end
  end

  describe ".project_branch", :vcr do
    it "get a specific branch of a project" do
      request = stub_get gitlab_url("/api/v3/projects/92029/repository/branches/master")
      @client.project_branch(92029, "master")
      assert_requested request
    end
  end

  describe ".protect_project_branch", :vcr do
    it "protects a single branch of a project" do
      request = stub_put gitlab_url("/api/v3/projects/92029/repository/branches/master/protect")
      @client.protect_project_branch(92029, "master")
      assert_requested request
    end
  end

  describe ".unprotect_project_branch", :vcr do
    it "protects a single branch of a project" do
      request = stub_put gitlab_url("/api/v3/projects/92029/repository/branches/master/unprotect")
      @client.unprotect_project_branch(92029, "master")
      assert_requested request
    end
  end

  describe ".add_forked_from_project", :vcr do
    it "create a fork relation" do
      request = stub_post gitlab_url("/api/v3/projects/92029/fork/1")
      @client.add_forked_from_project(92029, 1)
      assert_requested request
    end
  end

  describe ".delete_forked_from_project", :vcr do
    it "delete a frok relation" do
      request = stub_delete gitlab_url("/api/v3/projects/92029/fork")
      @client.delete_forked_from_project(92029)
      assert_requested request
    end
  end

  describe ".search_project", :vcr do
    it "search for projects by name" do
      request = stub_get gitlab_url("/api/v3/projects/search/test")
      @client.search_project("test")
      assert_requested request
    end
  end

end
