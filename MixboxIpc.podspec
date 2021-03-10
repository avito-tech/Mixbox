require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxIpc'
  s.platforms = [:ios, :osx]
  
  s.dependency 'MixboxFoundation'
end