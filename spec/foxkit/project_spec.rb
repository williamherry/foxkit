require 'spec_helper'

describe Foxkit::Project do
  context "when passed a string containg a slash" do
    before do
      @project = Foxkit::Project.new("sferik/octokit")
    end

    it "sets the project name and username" do
      expect(@project.name).to eq("octokit")
      expect(@project.username).to eq("sferik")
    end

    it "responds to repo and user" do
      expect(@project.repo).to eq("octokit")
      expect(@project.user).to eq("sferik")
    end

    it "renders slug as string" do
      expect(@project.slug).to eq("sferik/octokit")
      expect(@project.to_s).to eq(@project.slug)
    end

    it "renders url as string" do
      expect(@project.url).to eq('https://gitlab.com/sferik/octokit')
    end
  end

  describe ".path" do
    context "with project id" do
      it "returns theu url path" do
        project = Foxkit::Project.new(12345)
        expect(project.path).to eq gitlab_path('/projects/12345')
      end
    end
  end # .path

  describe "self.path" do
    it "returns the api path" do
      expect(Foxkit::Project.path(12345)).to eq gitlab_path('/projects/12345')
    end
  end

  context "when passed an integer" do
    it "sets the project id" do
      project = Foxkit::Project.new(12345)
      expect(project.id).to eq 12345
    end
  end

  context "when passed a hash" do
    it "sets the project name and username" do
      project = Foxkit::Project.new({:username => 'sferik', :name => 'octokit'})
      expect(project.name).to eq("octokit")
      expect(project.username).to eq("sferik")
    end
  end

  context "when passed a Repo" do
    it "sets the project name and username" do
      project = Foxkit::Project.new(Foxkit::Project.new('sferik/octokit'))
      expect(project.name).to eq("octokit")
      expect(project.username).to eq("sferik")
      expect(project.url).to eq('https://gitlab.com/sferik/octokit')
    end
  end

  context "when given a URL" do
    it "sets the project name and username" do
      project = Foxkit::Project.from_url("https://gitlab.com/sferik/octokit")
      expect(project.name).to eq("octokit")
      expect(project.username).to eq("sferik")
    end
  end
end
