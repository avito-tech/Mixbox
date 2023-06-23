# Example of sharing code between GrayBox and BlackBox UI tests.
#
# There are options for you:
# - Share code like this using a separate module.
# - Simply check files for both targets (your GrayBox and BlackBox targets).
# - Do not use GrayBox testing. So you won't need shared code.

# Note: you don't need this, this is just to keep demo up-to-date with other code
require_relative '../../cocoapods/software_versions'

Pod::Spec.new do |s|
  s.name                   = 'UiTestsSharedCode'
  s.module_name            = s.name 
  s.version                = '0.1.0'
  s.summary                = s.name 
  s.homepage               = 'https://github.com/avito-tech/Mixbox'
  s.license                = 'MIT'
  s.author                 = { 'Hive of coders from Avito' => 'avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Mixbox.git', :tag => "Mixbox-#{s.version}" }
  s.platform               = :ios, $mixbox_ios_version
  
  s.swift_version = $mixbox_swift_version
  s.requires_arc = true
  s.source_files = 'Sources/**/*.{swift,h,m,mm}'
  
  s.dependency 'MixboxUiTestsFoundation'
end
