# Changelog

All notable changes to this project will be documented in this file.

## 0.3.0

This version breaks backward compatibility, you have to patch your project settings.

### Major changes

- `MIXBOX_ENABLE_IN_APP_SERVICES` was removed. `MIXBOX_ENABLE_ALL_FRAMEWORKS` was added with same functionality.
- You can disable code in certain Mixbox frameworks with defines like `MIXBOX_DISABLE_FRAMEWORK_GENERATORS` (example for `MixboxGenerators` framework)
- You can enable code in certain Mixbox frameworks by using `MIXBOX_ENABLE_FRAMEWORK_GENERATORS` (example for `MixboxGenerators` framework).

Note that disabling and enabling same framework simultaneously will result in compilation.
Note that this is only a fail-safe mechanism, ideally you don't want to link the frameworks in your release builds.
