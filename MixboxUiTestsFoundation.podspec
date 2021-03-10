require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxUiTestsFoundation'
  s.platforms = [:ios]
  
  s.dependency 'MixboxTestsFoundation'
  s.dependency 'MixboxUiKit'
  s.dependency 'MixboxAnyCodable'
  s.dependency 'CocoaImageHashing'
  s.dependency 'MixboxIpcCommon'
  s.dependency 'MixboxDi'

  s.frameworks = 'XCTest'
  
  s.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PLATFORM_DIR)/Developer/Library/Frameworks'
  }
  
  s.xcconfig = {
    'ENABLE_TESTING_SEARCH_PATHS' => 'YES',
    'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift-$(SWIFT_VERSION)/$(PLATFORM_NAME) $(inherited)'
  }
end
