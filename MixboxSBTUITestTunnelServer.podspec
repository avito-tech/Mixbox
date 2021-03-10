require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxSBTUITestTunnelServer'
  s.platforms = [:ios]
  
  s.dependency 'MixboxSBTUITestTunnelCommon'
  
  s.dependency 'GCDWebServer', '~> 3.0'
end
