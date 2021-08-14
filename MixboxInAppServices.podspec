require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxInAppServices'
  s.platforms = [:ios]
  
  s.dependency 'MixboxIpcCommon'
  s.dependency 'MixboxTestability'
  s.dependency 'MixboxIpcSbtuiHost'
  s.dependency 'MixboxUiKit'
  s.dependency 'MixboxBuiltinIpc'
  s.dependency 'MixboxIoKit'
  s.dependency 'MixboxBuiltinDi'
  s.dependency 'MixboxSBTUITestTunnelServer'
  
  s.frameworks = 'UIKit'
end
