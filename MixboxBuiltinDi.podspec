require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxBuiltinDi'
  s.platforms = [:ios, :osx]
  
  s.dependency 'MixboxDi'
end
