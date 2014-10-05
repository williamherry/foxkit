require 'spec_helper'

describe Foxkit::Client::RepositoryFiles do
  before do
    Foxkit.reset!
    @client = token_auth_client
    @project = @client.projects.first
  end

  describe ".repository_files", :vcr do
    it "get a list of file with info" do
      file = @client.repository_files(
        @project.id, {file_path: "README", ref: "master"})
      expect(file.ref).to eq "master"
    end
  end

  describe ".create_repository_file", :vcr do
    it "create a file in repository" do
      file_info = {
        file_path: "test_file_create.rb",
        branch_name: "master",
        encoding: "text",
        content: "test file create",
        commit_message: "test file create"
      }
      file = @client.create_repository_file(@project.id, file_info)
      expect(file[:file_path]).to eq "test_file_create.rb"

      # cleanup
      begin
        @client.delete_repository_file(@project.id, file_info)
      rescue Foxkit::NotFound
      end
    end
  end

  describe ".update_repository_file", :vcr do
    it "update a file in repository" do
      file_info = {
        file_path: "test_file_create.rb",
        branch_name: "master",
        encoding: "text",
        content: "test file create",
        commit_message: "test file create"
      }
      @client.create_repository_file(@project.id, file_info)
      @client.update_repository_file(
        @project.id, file_info.merge(content: 'test file update')
      )
      file = @client.repository_files(
        @project.id, {file_path: "test_file_create.rb", ref: "master"}
      )
      expect(file["content"]).to eq "dGVzdCBmaWxlIHVwZGF0ZQ==\n"

      # cleanup
      begin
        @client.delete_repository_file(@project.id, file_info)
      rescue Foxkit::NotFound
      end
    end
  end
end
