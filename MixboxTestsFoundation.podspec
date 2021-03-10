require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxTestsFoundation'
  s.platforms = [:ios]
  
  s.dependency 'MixboxFoundation'
  s.dependency 'MixboxUiKit'
  s.dependency 'MixboxBuiltinDi'
  
  s.dependency 'SQLite.swift'
  
  s.frameworks = 'XCTest', 'XCTAutomationSupport', 'CoreLocation'
  
  s.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PLATFORM_DIR)/Developer/Library/Frameworks'
  }
  
  s.xcconfig = {
    'ENABLE_TESTING_SEARCH_PATHS' => 'YES',
    'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift-$(SWIFT_VERSION)/$(PLATFORM_NAME) $(inherited)',
    'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/usr/lib" "$(PLATFORM_DIR)/Developer/Library/Frameworks" "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks" "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"'
  }
end
