require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxBuiltinIpc'
  s.platforms = [:ios, :osx]
  
  s.dependency 'MixboxIpc'
  s.dependency 'GCDWebServer'
end