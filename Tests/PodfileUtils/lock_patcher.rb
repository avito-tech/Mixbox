# Podfile.lock contains PODFILE CHECKSUM that leads to git conflicts, but we really don't need it
# Maybe you think that CHECKSUM increses `pod install` by caching, but measurements show no difference
#
# at_exit waits until `pod install` finishes (we can't do it in post_install hook, because
# Podfile.lock is not updated at this stage)
at_exit do
  podfile_lock_path = "#{Dir.pwd}/Podfile.lock"
  manifest_lock_path = "#{Dir.pwd}/Pods/Manifest.lock"
  podfile_lock_contents = File.read(podfile_lock_path)

  # Removes such conflicts:
  # <<<<<<<
  # PODFILE CHECKSUM: d304528e72925f278d0fb9367fc5b9720bda81df
  # =======
  # PODFILE CHECKSUM: 7cda18b5689dc7f854794b2100de67edfe1123e5
  # >>>>>>>
  #
  # Interesting facts: if checksum contains only numbers [0-9], Cocoapods crashes.
  podfile_lock_contents = podfile_lock_contents.gsub(/^PODFILE CHECKSUM: '?[0-9a-f]{40}'?$/, 'PODFILE CHECKSUM: f000000000000000000000000000000000000000')

  # Removes such diff:
  # -    :path: ../MixboxFoundation/FileLine
  # +    :path: "../MixboxFoundation/FileLine"
  # The code will keep quotes.
  podfile_lock_contents = podfile_lock_contents.gsub(/^    :path: ([^"].*?[^"])$/, '    :path: "\1"')

  # Removes such diff:
  # -  GoogleSignIn: 09036ed61f8e75f1424100d63f7719480b2428c3
  # +  GoogleSignIn: '09036ed61f8e75f1424100d63f7719480b2428c3'
  # The code will remove quotes.
  podfile_lock_contents = podfile_lock_contents.gsub(/^  (.*?): '([0-9a-f]{40})'$/, '  \1: \2')

  # Writing to Podfile.lock and Manifest.lock:
  File.open(podfile_lock_path, "w") {|file| file.puts podfile_lock_contents }
  File.open(manifest_lock_path, "w") {|file| file.puts podfile_lock_contents }
end
