require_relative 'mixbox_version'

module Mixbox
  class FrameworkSpec < Pod::Spec
    attr_accessor :platforms # Example: [:ios, :osx]
    
    def initialize()
      super()
      
      framework_folder = "Frameworks/#{self.framework_folder_name}"
      
      attributes_hash['module_name'] = self.name
      attributes_hash['version'] = $mixbox_version
      attributes_hash['summary'] = self.name
      attributes_hash['homepage'] = 'https://github.com/avito-tech/Mixbox'
      attributes_hash['license'] = 'MIT'
      attributes_hash['authors'] = { 'Hive of coders from Avito' => 'avito.ru' }
      attributes_hash['source'] = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => $mixbox_version }
      attributes_hash['swift_version'] = '5.0'
      attributes_hash['requires_arc'] = true
      attributes_hash['source_files'] = "#{framework_folder}/Sources/**/#{self.source_files_mask}"
      attributes_hash['resources'] = "#{framework_folder}/Resources/**/*"
      
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
    
    def source_files_mask()
      return '*.{swift,h,m,mm,c}'
    end
    
    def framework_folder_name()
      return self.name.sub(/^Mixbox/, '')
    end
  end
end