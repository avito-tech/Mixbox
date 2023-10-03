# Inhibit this warning in Xcode:
# ```
# The iOS Simulator deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 8.0,
# but the range of supported deployment target versions is 11.0 to 17.0.
# ```
def inhibit_pod_deployment_target_warning()
  project = Xcodeproj::Project.open('Pods/Pods.xcodeproj')

  project.native_targets.each do |target|
    target_names_to_patch = ['GCDWebServer-iOS', 'GCDWebServer-macOS', 'GCDWebServer', 'SQLite.swift']
    if target_names_to_patch.include? target.name
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $mixbox_ios_version
        config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = $mixbox_osx_version
      end
    end
  end

  project.save
end