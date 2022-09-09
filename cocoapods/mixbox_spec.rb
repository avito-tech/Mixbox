require_relative 'mixbox_podspecs_source'

module Mixbox
  class BaseSpec < Pod::Spec
    attr_accessor :platforms # Example: [:ios, :osx]
    
    def initialize()
      super()
      
      mixbox_version = MixboxVersionProvider.get_mixbox_version

      if attributes_hash['module_name'].nil?
        attributes_hash['module_name'] = name
      end
      attributes_hash['version'] = mixbox_version
      
      if self.summary.blank?
        attributes_hash['summary'] = self.name
      end
      
      attributes_hash['homepage'] = 'https://github.com/avito-tech/Mixbox'
      attributes_hash['license'] = 'MIT'
      attributes_hash['authors'] = { 'Hive of coders from Avito' => 'avito.ru' }
      attributes_hash['source'] = { :git => $mixbox_podspecs_source, :tag => mixbox_version }
      attributes_hash['swift_version'] = '5.0'
      attributes_hash['requires_arc'] = true
      
      if self.platforms.include? :ios
        ios.deployment_target  = '9.0'
      end
      
      if self.platforms.include? :osx
        osx.deployment_target  = '10.14'
      end
      
      if self.platforms.empty?
        raise Exception.new "'platforms' isn't set in spec!"
      end
    end
    
    def get_source_files_mask()
      return '*.{swift,h,m,mm,c}'
    end
  end
  
  class FrameworkSpec < BaseSpec
    def initialize()
      super()
      
      framework_folder = "Frameworks/#{self.get_framework_folder_name}"
      
      attributes_hash['source_files'] = "#{framework_folder}/Sources/**/#{self.get_source_files_mask}"
      
      # Podspec doesn't validate if there are no resource files and `resources` is set.
      resources_folder_glob = "#{framework_folder}/Resources/**/*"
      if not Dir.glob(resources_folder_glob).empty?
        attributes_hash['resources'] = resources_folder_glob
      end
    end
    
    def get_framework_folder_name()
      return self.name.sub(/^Mixbox/, '')
    end
  end
  
  class MixboxVersionProvider
    @@cached_version = nil
    
    def self.get_mixbox_version()
      # Can be used to avoid unnecessary changes in Podfile.lock (if development pods are used)
      if ENV["MIXBOX_SET_VERSION_TO_001"] == "true"
        return "0.0.1"
      end
      
      if not @@cached_version
        # This code:
        # 1. Gets all revisions as tags
        # 2. Filters only version tags
        # 3. Gets first (latest) version tag.
        # The fallback value is 0.0.1
        @@cached_version = %x(
          git describe --always --abbrev=0 --tags `git rev-list --tags` | \
          grep -oE "^[0-9]+\.[0-9]+\.[0-9]+$" | \
          head -1 2>/dev/null \
          || echo 0.0.1
        ).strip
      end
      
      @@cached_version
    end
  end
end
