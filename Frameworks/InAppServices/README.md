#  MixboxInAppServices

A facade for including in app. Contains lots of tools that increase testability of the app.

Example usage:

```
// Should be always alive!
let mixboxInAppServices = MixboxInAppServices()
if let mixboxInAppServices = mixboxInAppServices {
	mixboxInAppServices.start()
}
```

Customization:

```
mixboxInAppServices.register(
	methodHandler: MyCustomIpcMethodHandler()
)
```
