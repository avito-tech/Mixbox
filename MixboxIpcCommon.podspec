Pod::Spec.new do |s|
  s.name                   = 'MixboxIpcCommon'
  s.module_name            = s.name
  s.version                = '0.0.2'
  s.summary                = s.name
  s.homepage               = 'https://github.com/avito-tech/Mixbox'
  s.license                = 'MIT'
  s.author                 = { 'Hive of coders from Avito' => 'avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => "Mixbox-#{s.version}" }
  s.platform               = :ios, '9.0'
  s.ios.deployment_target  = "9.0"
  s.swift_version = '4.0'
  s.requires_arc           = true
  s.source_files           = 'Frameworks/IpcCommon/**/*.{swift,h,m,md}'
  
  s.dependency 'MixboxIpc'
end