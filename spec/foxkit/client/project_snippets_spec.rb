require 'spec_helper'

describe Foxkit::Client::ProjectSnippets do
  before do
    Foxkit.reset!
    @client = token_auth_client

    @project = @client.projects.first
    @snippet = @client.create_project_snippet(
      @project.id, {title: 's1', file_name: 's1.rb', code: 's1'}
    )
  end

  after do
    begin
      @client.delete_project_snippet(@project.id, @snippet.id)
    rescue Foxkit::NotFound
    end
  end

  describe ".project_snippets", :vcr do
    it "should get project snippets" do
      snippets = @client.project_snippets(@project.id)
      expect(snippets.first.id).to eq @snippet.id
    end
  end

  describe ".project_snippet", :vcr do
    it "should get a project snippet" do
      expect(@client.project_snippet(@project.id, @snippet.id).id).to eq @snippet.id
    end
  end

  describe ".create_project_snippet", :vcr do
    it "create a snippet" do
      expect(@snippet.id).to be_kind_of Integer
    end
  end

  describe ".update_project_snippet", :vcr do
    it "update a snippet" do
      new_snippet = @client.update_project_snippet(
        @project.id, @snippet.id, title: 's2'
      )
      expect(@client.project_snippet(@project.id, @snippet.id).title).to eq "s2"
    end
  end

  describe ".project_snippet_content", :vcr do
    it "get content of a snippet" do
      expect(@client.project_snippet_content(@project.id, @snippet.id)).to eq "s1"
    end
  end

end
