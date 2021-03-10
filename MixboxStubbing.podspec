require_relative 'cocoapods/mixbox_spec'

Mixbox::FrameworkSpec.new do |s|
  s.name = 'MixboxStubbing'
  s.platforms = [:ios]

  s.dependency 'MixboxGenerators'
  s.dependency 'MixboxTestsFoundation'
  
  s.xcconfig = {
    'ENABLE_TESTING_SEARCH_PATHS' => 'YES'
  }
end
