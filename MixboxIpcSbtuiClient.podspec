require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxIpcSbtuiClient'
  s.platforms = [:ios]
  
  s.dependency 'MixboxIpc'
  s.dependency 'MixboxSBTUITestTunnelClient'
  
  # for network mocks,  kind of a kludge, but SBTUITestTunnel should be removed soon:
  s.dependency 'MixboxTestsFoundation' 
  s.dependency 'MixboxUiTestsFoundation'
  
  s.framework = "XCTest"

  s.pod_target_xcconfig = {
    'ENABLE_TESTING_SEARCH_PATHS' => 'YES',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"'
  }
end