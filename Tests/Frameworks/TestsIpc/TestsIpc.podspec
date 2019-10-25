Pod::Spec.new do |s|
  s.name                   = 'TestsIpc'
  s.module_name            = s.name 
  s.version                = '0.1.0'
  s.summary                = s.name 
  s.homepage               = 'https://github.com/avito-tech/Mixbox'
  s.license                = 'MIT'
  s.author                 = { 'Hive of coders from Avito' => 'avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => "Mixbox-#{s.version}" }
  s.platform               = :ios, '9.0'
  s.ios.deployment_target = "9.0"
  s.swift_version = '5.0'
  s.requires_arc = true
  s.source_files = '**/*.{swift,h,m,mm}'
  
  s.dependency 'MixboxIpc'
  s.dependency 'MixboxBuiltinIpc'
  s.dependency 'MixboxIpcCommon'
end
