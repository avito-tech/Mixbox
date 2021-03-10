require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxIpcSbtuiHost'
  s.platforms = [:ios]
  
  s.dependency 'MixboxIpc'
  s.dependency 'MixboxSBTUITestTunnelServer'
end