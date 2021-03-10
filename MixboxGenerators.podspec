require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxGenerators'
  s.platforms = [:ios]

  s.dependency 'MixboxDi'
end
