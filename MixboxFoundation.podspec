require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxFoundation'
  s.platforms = [:ios, :osx]
end