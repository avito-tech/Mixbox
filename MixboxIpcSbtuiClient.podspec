Pod::Spec.new do |s|
  s.name                   = 'MixboxIpcSbtuiClient'
  s.module_name            = s.name
  s.version                = '0.1.0'
  s.summary                = s.name
  s.homepage               = 'https://github.com/avito-tech/Mixbox'
  s.license                = 'MIT'
  s.author                 = { 'Hive of coders from Avito' => 'avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => "Mixbox-#{s.version}" }
  s.platform               = :ios, '9.0'
  s.ios.deployment_target  = "9.0"
  s.swift_version = '4.0'
  s.requires_arc           = true
  s.source_files           = 'Frameworks/IpcSbtuiClient/**/*.{swift,h,m,md}'
  
  s.dependency 'MixboxIpc'
  s.dependency 'SBTUITestTunnel/Client', '~> 3.0.6'
  
  # for network mocks,  kind of a kludge, but SBTUITestTunnel should be removed soon:
  s.dependency 'MixboxTestsFoundation' 
  s.dependency 'MixboxUiTestsFoundation'
  s.dependency 'MixboxXcuiDriver'
  
  s.framework = "XCTest"
  s.user_target_xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(PLATFORM_DIR)/Developer/Library/Frameworks' }
end