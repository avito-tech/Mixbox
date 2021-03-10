require 'git'
require 'cocoapods'
require 'find'

module Devpods
  class RepoSettings
    attr_reader :repo_url
    attr_reader :pod_function
    attr_accessor :cached_repo_path

    def initialize(repo_url, pod_function, required_commit, required_local_path, required_branch)
      @repo_url = repo_url
      @pod_function = pod_function
      @required_commit = required_commit
      @required_local_path = required_local_path
      @required_branch = required_branch
    end

    public
    def podspec_by_name
      @podspec_by_name = get_podspec_by_name
    end

    private
    def get_podspec_by_name
      podspec_by_name = {}
      Dir.glob("#{get_repo_path}/*\\.podspec").each { |podspec_path|
        name = File.basename(podspec_path, '.podspec')
        podspec = Pod::Specification.from_file(podspec_path)

        podspec_by_name[name] = podspec
      }

      podspec_by_name
    end

    private
    def repo_path
      @repo_path = get_repo_path
    end

    private
    def get_repo_path
      if @required_local_path
        @required_local_path
      else
        clone_repo_and_get_path
      end
    end

    private
    def clone_repo_and_get_path
      if not @cached_repo_path
        tmpdir = Dir.mktmpdir
        repo_name = 'git-repository'
        repo = Git.clone(@repo_url, repo_name, :path => tmpdir, :depth => 1, :branch => @required_branch)

        commit = get_commit_as_checkout_options
        if commit
          repo.checkout(commit)
        end
        
        @cached_repo_path = File.join(tmpdir, repo_name)
      end
      
      @cached_repo_path
    end

    public
    def pod_function_hash
      @pod_function_hash ||= get_pod_function_hash
      @pod_function_hash.clone
    end

    private
    def get_pod_function_hash
      if @required_local_path
        { :path => @required_local_path }
      else
        commit = commit_as_pod_requirement
        if commit
          { :git => repo_url, :commit => commit }
        else
          { :git => repo_url, :branch => @required_branch }
        end
      end
    end

    # Commit to use in `pod` function invocation
    def commit_as_pod_requirement
      if @required_local_path
        nil
      else
        @required_commit
      end
    end

    # Commit to use in checkout options
    private
    def commit_as_checkout_options
      @commit_as_checkout_options ||= get_commit_as_checkout_options
    end
    
    private
    def get_commit_as_checkout_options
      if commit_as_pod_requirement
        commit_as_pod_requirement
      else
        # TODO: Fix it. It doesn't work. it recurively triggers cloning the repo.
        nil
        
        # lockfile_path = Find.find(Dir.pwd).find { |f| f =~ /Podfile.lock$/ }
        # lockfile = Pod::Lockfile.from_file(Pathname.new(lockfile_path))
        # if lockfile
        #   podspec_by_name.keys
        #     .map { |name| lockfile.checkout_options_for_pod_named(name)[:commit] }
        #     .compact
        #     .first
        # else
        #   nil
        # end
      end
    end
  end
end