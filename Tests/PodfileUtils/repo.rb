require_relative 'repo_with_settings'
require_relative 'repo_settings'

module Devpods
  class Repo
    attr_reader :repo_url
    attr_reader :pod_function
    attr_accessor :commit_env
    attr_accessor :commit_value
    attr_accessor :local_path_env
    attr_accessor :local_path_value
    attr_accessor :branch_env
    attr_accessor :branch_value

    def initialize(repo_url, pod_function)
      @repo_url = repo_url
      @pod_function = pod_function
    end

    public
    def pod(name)
      repo_with_settings.pod(name)
    end

    public
    def all_pods
      repo_with_settings.all_pods
    end

    private
    def repo_with_settings
      @repo_with_settings ||= get_repo_with_settings
    end

    private
    def get_repo_with_settings
      repo_settings = Devpods::RepoSettings.new(
        @repo_url,
        @pod_function,
        @commit_value || (@commit_env ? ENV[@commit_env] : nil),
        @local_path_value || (@local_path_env ? ENV[@local_path_env] : nil),
        @branch_value || (@branch_value ? ENV[@branch_env] : nil)
      )
      Devpods::RepoWithSettings.new(repo_settings)
    end
  end
end