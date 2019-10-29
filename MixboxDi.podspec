Pod::Spec.new do |s|
  s.name                   = 'MixboxDi'
  s.module_name            = s.name
  s.version                = '0.2.3'
  s.summary                = s.name
  s.homepage               = 'https://github.com/avito-tech/Mixbox'
  s.license                = 'MIT'
  s.author                 = { 'Hive of coders from Avito' => 'avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => "Mixbox-#{s.version}" }
  s.ios.deployment_target  = '9.0'
  s.osx.deployment_target  = '10.14'
  s.swift_version          = '5.0'
  s.requires_arc           = true
  s.source_files           = 'Frameworks/Di/**/*.{swift,h,m,mm}'
  
  s.dependency 'Dip'
  s.dependency 'MixboxFoundation'
end