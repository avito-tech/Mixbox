# This is a minimal required settings to make Mixbox work.
# Use it only for debug/testing configuration, because otherwise the code will be released into production.
# If you only enable it for Debug configuration, no code will be released in production and this
# is strictly checked in CI - no code can be pushed to master if it can leak to production.
#
# This is just a ssafety measure, because ideally you should only link frameworks in Debug configuration (or whatever you use for testing).
#
# Example with `Devpods`:
#
# mixbox = Devpods::Repo.new(
#   'ssh://git@github.com:avito-tech/Mixbox.git',
#   lambda { |name, hash|
#     local_hash = hash.clone
#     local_hash[:inhibit_warnings] = false
#     local_hash[:configurations] = ['Debug']
#     pod name, local_hash
#   }
# )
#
# Example with just Cocoapods (note that Mixbox is not currently released due to unfinished CI/CD for community)
#
# pod 'MixboxBlack', :configurations => ['Debug'], :git => 'ssh://git@github.com:avito-tech/Mixbox.git', :branch => 'master'
#
def enable_testing_with_mixbox_for_configuration_name(configuration_name)
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |configuration|
        if configuration.name == configuration_name
          enable_testing_with_mixbox_for_module_configuration(configuration)
        end
      end
    end
  end
end

def enable_testing_with_mixbox_for_module_configuration(config)
  # NOTE: You may want to add add '-Onone' for your debug builds so they will be compiled faster.

  # MIXBOX_ENABLE_IN_APP_SERVICES enables code for testing. You should not include that code in release builds.
  config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-D', 'MIXBOX_ENABLE_IN_APP_SERVICES']

  # ENABLE_UITUNNEL is a same thing, but for SBTUITestTunnel library. We're planning to stop using it. If there is no such dependency now, remove this definition.
  config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'ENABLE_UITUNNEL=1', 'MIXBOX_ENABLE_IN_APP_SERVICES=1']
end