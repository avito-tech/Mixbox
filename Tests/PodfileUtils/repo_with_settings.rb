module Devpods
  class RepoWithSettings

    def initialize(repo_settings)
      @repo_settings = repo_settings
    end

    public
    def pod(name)
      podspec = @repo_settings.podspec_by_name[name]

      if podspec
        podspec.all_dependencies.each do |dependency|
          if @repo_settings.podspec_by_name[dependency.name]
            pod(dependency.name)
          end
        end
      end

      @repo_settings.pod_function.call(name, @repo_settings.pod_function_hash)
    end
    
    public
    def all_pods
      @repo_settings.podspec_by_name.keys
    end
  end
end
