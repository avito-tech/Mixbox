require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxMocksGeneration'
  s.platforms = [:osx]
  
  s.dependency 'SourceryFramework'
  s.dependency 'SourceryRuntime'
end
