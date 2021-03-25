require_relative 'cocoapods/mixbox_spec'

Mixbox::BaseSpec.new do |s|
  s.name = 'Mixbox'
  s.platforms = [:ios]
  
  s.summary = 'This pod is reserved for future use. It should not be used at the moment.'
  
  s.subspec 'Foundation' do |ss|
    ss.dependency 'MixboxFoundation'
  end 
end