require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxUiTestsFoundation'
  s.platforms = [:ios]
  
  s.dependency 'MixboxTestsFoundation'
  s.dependency 'MixboxUiKit'
  s.dependency 'MixboxAnyCodable'
  s.dependency 'MixboxCocoaImageHashing'
  s.dependency 'MixboxIpcCommon'
  s.dependency 'MixboxDi'

  s.frameworks = 'XCTest'
  
  s.pod_target_xcconfig = {
     'ENABLE_TESTING_SEARCH_PATHS' => 'YES',
     'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"'
  }
end
