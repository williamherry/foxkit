require 'spec_helper'

describe Foxkit::Client::Repositories do
  before do
    Foxkit.reset!
    @client = token_auth_client
    @project = @client.projects.first
  end

  describe ".repository_tags", :vcr do
    it "list tags of a repository" do
      tags = @client.repository_tags(@project.id)
      expect(tags).to be_kind_of Array
    end
  end

  describe ".create_repository_tag", :vcr do
    it "create a repository tag" do
      tag = @client.create_repository_tag(
        @project.id, {tag_name: 'tag1', ref: 'master', message: 'msg1'}
      )
      tags = @client.repository_tags(@client.projects.first.id)
      expect(tags.first.name).to eq "tag1"
    end
  end

  describe ".repository_tree", :vcr do
    it "list repository files and directories in a project" do
      tree = @client.repository_tree(@project.id)
      expect(tree).to be_kind_of Array
    end
  end

  describe ".repository_raw_file_content", :vcr do
    it "get the raw file contents for a file by commit SHA and path" do
      content = @client.repository_raw_file_content(
        @project.id, "310994", "README"
      )
      expect(content). to eq ""
    end
  end

  describe ".repository_raw_blob_content", :vcr do
    it "get the raw file contents for a blob by blob SHA" do
      content = @client.repository_raw_blob_content(
        @project.id, "e69d"
      )
      expect(content).to eq ""
    end
  end

  describe ".repository_archive", :vcr do
    it "get an archive of the repository" do
      archive = @client.repository_archive(@project.id)
      expect(archive.length).not_to eq 0
    end
  end

  describe ".repository_diff_between", :vcr do
    it "get difference between branches|tags|commits" do
      diffs = @client.repository_diff_between(
        @project.id, {from: "master", to: "master"}
      )
      expect(diffs[:diffs]).to eq []
    end
  end

  describe ".repository_contributors", :vcr do
    it "get repository contributors list" do
      contributors = @client.repository_contributors(@project.id)
      expect(contributors.first.name).to eq "William Herry"
    end
  end
end
