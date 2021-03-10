require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxReflection'
  s.platforms = [:ios, :osx]
end
