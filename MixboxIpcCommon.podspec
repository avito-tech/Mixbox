require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxIpcCommon'
  s.platforms = [:ios]
  
  s.dependency 'MixboxIpc'
  s.dependency 'MixboxAnyCodable'
end