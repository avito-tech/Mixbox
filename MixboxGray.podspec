Pod::Spec.new do |s|
  s.name                   = 'MixboxGray'
  s.module_name            = s.name
  s.version                = '0.2.0'
  s.summary                = s.name
  s.homepage               = 'https://github.com/avito-tech/Mixbox'
  s.license                = 'MIT'
  s.author                 = { 'Hive of coders from Avito' => 'avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => "Mixbox-#{s.version}" }
  s.platform               = :ios, '9.0'
  s.ios.deployment_target = "9.0"
  s.swift_version = '4.0'
  s.requires_arc = true
  s.source_files = 'Frameworks/Gray/**/*.{swift,h,m,md}'

  s.dependency 'MixboxUiTestsFoundation'
  s.dependency 'MixboxUiKit'
  s.dependency 'MixboxInAppServices'
  
  s.frameworks = 'XCTest', 'IOKit', 'XCTAutomationSupport'
  
  xcconfig = {
    'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks" "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks" "$(PLATFORM_DIR)/Developer/Library/PrivateFrameworks"'
  }
  if ENV['MIXBOX_CI_IS_LINTING_PODSPECS'] == 'true'
    xcconfig['OTHER_SWIFT_FLAGS'] = '$(inherited) -D MIXBOX_CI_IS_LINTING_PODSPECS -D MIXBOX_ENABLE_IN_APP_SERVICES'
    xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] = '$(inherited) MIXBOX_CI_IS_LINTING_PODSPECS=1 MIXBOX_ENABLE_IN_APP_SERVICES=1'
  end
  s.xcconfig = xcconfig

end
