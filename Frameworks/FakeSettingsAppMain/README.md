# About

This code simplifies making Fake Settings App for setting notifications permissions (via `FakeSettingsAppNotificationsApplicationPermissionSetter`)

## Installation

Create target with any name and bundle id. Example: `FakeSettingsApp`, `mixbox.FakeSettingsApp`.

Use these entitlements: [Entitlements.entitlements](Example/Entitlements.entitlements)

Call `FakeSettingsAppMain` from main. Example of `main.swift`:

```
import MixboxFakeSettingsAppMain

FakeSettingsAppMain(CommandLine.argc, CommandLine.unsafeArgv)
```

In your tests init the client for this app:

```
FakeSettingsAppNotificationsApplicationPermissionSetter(
    bundleId: "bundle.id.of.any.app",
    displayName: "Its display name",
    fakeSettingsAppBundleId: "mixbox.FakeSettingsApp") // remember that you can use other bundle id
)
```
