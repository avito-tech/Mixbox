## Oversimplified Demo

This is not how we use Mixbox in Avito. This is a concept of how it can be used.

You can just link something in your app and something in your tests:

```
target 'MyApp' do
  pod 'MixboxInAppServices', '0.2.2'
end

target 'MyUITests' do
  pod 'MixboxXcuiDriver', '0.2.2'
end
```

In Avito we specify version of every intermediate third-party library, specify name of every Mixbox library. That allows us to fetch Mixbox from different sources (which helps with developing Mixbox), fetch specific verisons of libraries. Podfile looks like this:

```
def ui_tests_and_app_common_pods
  mixbox_pod 'MixboxIpc'
  mixbox_pod 'MixboxIpcCommon'
  mixbox_pod 'MixboxUiKit'
  mixbox_pod 'MixboxBuiltinIpc'
  mixbox_pod 'MixboxFoundation'
  mixbox_pod 'MixboxArtifacts'
  ...
```

This repository contains [tests project](../Tests) that uses the latter approach. You can use it as an example of how to use certain features.

## How to use

* pod install
* cmd+U