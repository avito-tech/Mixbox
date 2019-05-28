Pod::Spec.new do |s|
  s.name                   = 'MixboxIpc'
  s.module_name            = s.name
  s.version                = '0.2.0'
  s.summary                = s.name
  s.homepage               = 'https://github.com/avito-tech/Mixbox'
  s.license                = 'MIT'
  s.author                 = { 'Hive of coders from Avito' => 'avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => "Mixbox-#{s.version}" }
  s.ios.deployment_target  = "9.0"
  s.osx.deployment_target  = "10.13"
  s.swift_version          = '4.0'
  s.requires_arc           = true
  s.source_files           = 'Frameworks/Ipc/**/*.{swift,h,m,md}'
  
  s.dependency 'MixboxFoundation'

  xcconfig = {}
  if ENV['MIXBOX_CI_IS_LINTING_PODSPECS'] == 'true'
    xcconfig['OTHER_SWIFT_FLAGS'] = '$(inherited) -D MIXBOX_CI_IS_LINTING_PODSPECS -D MIXBOX_ENABLE_IN_APP_SERVICES'
    xcconfig['GCC_PREPROCESSOR_DEFINITIONS'] = '$(inherited) MIXBOX_CI_IS_LINTING_PODSPECS=1 MIXBOX_ENABLE_IN_APP_SERVICES=1'
  end
  s.xcconfig = xcconfig
end