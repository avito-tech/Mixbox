require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxSBTUITestTunnelClient'
  s.platforms = [:ios]
  
  s.dependency 'MixboxSBTUITestTunnelCommon'
  
  s.frameworks = 'XCTest'
end
