require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxLinkXCTAutomationSupport'
  s.platforms = [:ios]

  # This is one of the allowed names from "otool -l XCTAutomationSupport | grep -A 2 LC_SUB_CLIENT"
  s.module_name = 'AutomationInfrastructureIntegrationTests'

  s.pod_target_xcconfig = {
    'ENABLE_TESTING_SEARCH_PATHS' => 'YES',
    'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks" "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"',
    'REEXPORTED_FRAMEWORK_NAMES' => 'XCTAutomationSupport'
  }
end
