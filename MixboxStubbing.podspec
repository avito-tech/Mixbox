require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxStubbing'
  s.platforms = [:ios]

  s.dependency 'MixboxGenerators'
  s.dependency 'MixboxTestsFoundation'

  s.pod_target_xcconfig = {
    'ENABLE_TESTING_SEARCH_PATHS' => 'YES',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"'
  }
end
