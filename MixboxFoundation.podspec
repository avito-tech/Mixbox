Pod::Spec.new do |s|
  s.name                   = 'MixboxFoundation'
  s.module_name            = s.name 
  s.version                = '0.2.3'
  s.summary                = 'Shared simple general purpose utilities' 
  s.homepage               = 'https://github.com/avito-tech/Mixbox'
  s.license                = 'MIT'
  s.author                 = { 'Hive of coders from Avito' => 'avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => "Mixbox-#{s.version}" }
  s.ios.deployment_target  = "9.0"
  s.osx.deployment_target  = "10.13"
  s.swift_version = '4.0'
  s.requires_arc = true
  s.source_files = 'Frameworks/Foundation/**/*.{swift,h,m,md}'
end