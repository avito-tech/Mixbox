require_relative '../../../cocoapods/mixbox_spec'

Mixbox::TestsSupportFrameworkSpec.new do |s|
  s.name = 'TestsIpc'
  s.platforms = [:ios]
  
  s.dependency 'MixboxUiKit'
  s.dependency 'MixboxIpc'
  s.dependency 'MixboxBuiltinIpc'
  s.dependency 'MixboxIpcCommon'
  s.dependency 'MixboxReflection'
  s.dependency 'MixboxGenerators'
end
