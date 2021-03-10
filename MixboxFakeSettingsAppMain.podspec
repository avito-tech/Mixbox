require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxFakeSettingsAppMain'
  s.platforms = [:ios]
end