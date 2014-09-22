module Foxkit

  # Class to parse GitLab Project owner and name from
  # URLs and to generate URLs
  class Project
    attr_accessor :owner, :name, :id

    # Instantiate from a GitLab project URL
    #
    # @return [Project]
    def self.from_url(url)
      Project.new(URI.parse(url).path[1..-1])
    end

    def initialize(project)
      case project
      when Integer
        @id = project
      when String
        @owner, @name = project.split('/')
      when Project
        @owner = project.owner
        @name = project.name
      when Hash
        @name = project[:project] ||= project[:name]
        @owner = project[:owner] ||= project[:user] ||= project[:username]
      end
    end

    # Project owner/name
    # @return [String]
    def slug
      "#{@owner}/#{@name}"
    end
    alias :to_s :slug

    # @return [String] Project API path
    def path
      "api/v3/projects/#{@id}"
    end

    # Project URL based on {Foxkit::Client#web_endpoint}
    # @return [String]
    def url
      "#{Foxkit.web_endpoint}#{slug}"
    end

    # Get the api path for a project
    # @param project [Integer, String, Hash, Project] A GitLab Project.
    # @return [String] Api path.
    def self.path project
      new(project).path
    end

    alias :user :owner
    alias :username :owner
    alias :repo :name
  end
end
