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
    def all_pods(&filter)
      @repo_settings.podspec_by_name
        .select { |podspec_name, podspec| filter.call(podspec_name, podspec) }
        .map { |podspec_name, podspec| podspec_name }
    end
  end
end
