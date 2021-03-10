require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxIoKit'
  s.platforms = [:ios]
  
  s.dependency 'MixboxFoundation'
  
  s.frameworks = 'IOKit', 'UIKit'
end
