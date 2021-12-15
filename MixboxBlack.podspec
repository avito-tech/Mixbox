require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxBlack'
  s.platforms = [:ios]

  s.dependency 'MixboxFoundation'
  s.dependency 'MixboxUiTestsFoundation'
  s.dependency 'MixboxIpcSbtuiClient'
  s.dependency 'MixboxSBTUITestTunnelClient'
  s.dependency 'MixboxSBTUITestTunnelCommon'
  s.dependency 'MixboxDi'
  s.dependency 'MixboxIpc'
  s.dependency 'MixboxIpcCommon'
  s.dependency 'MixboxTestsFoundation'
  
  s.frameworks = 'XCTest', 'XCTAutomationSupport'
  
  s.pod_target_xcconfig = {
    'ENABLE_TESTING_SEARCH_PATHS' => 'YES',
    'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/usr/lib" "$(PLATFORM_DIR)/Developer/Library/Frameworks" "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"'
  }
end
