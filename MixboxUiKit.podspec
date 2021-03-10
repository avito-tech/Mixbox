require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxUiKit'
  s.platforms = [:ios]
  
  s.dependency 'MixboxFoundation'
end