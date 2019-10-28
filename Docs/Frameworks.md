# Frameworks

Mixbox is designed to support multiple kinds of tests. Assume that you have an "Application" target and test targets ("White", "Gray", and "Black").

Due to high amount of possible targets there are so many frameworks.

(note that currently only "Black" is somehow usable)

The way that frameworks are divided may be changed in future.

The following picture is quite outdated, but the idea is same:

![Dependencies](Images/Dependencies.png)

White-box tests target (e.g. unit tests) may use this:

* **MixboxTestsFoundation**: contains code that can be used for every iOS test, e.g. cleaning system state, working with XCTest, etc.
* **MixboxFoundation**: just very generic utilities that are used in almost every other framework.

Grey-box tests target may use this:

* **MixboxGray**: An implementaion of UI testing when tests are executed within app's process.
* **MixboxUiTestsFoundation**: Shared interfaces for UI testing and tools for UI testing. Shared interfaces allow to share also your code, e.g. your page objects.
* **MixboxUiKit**: Same as Foundation, but requires UIKit
 No newline at end of file
 
Black-box tests target may use this:

* **MixboxBlack**: An implementaion of UI testing based on XCUI
* **MixboxIpcClients**: Clients for communication with the Application, for example to get data or simulate something like keyboard/touches/push notifications/etc.
* TBD

Application should provide some extra information for tests, it will use:

* **MixboxInAppServices**: a facade for everything that is related for supporting tests
* **MixboxTestablity**: interfaces that can make your app testable. Why it is a separate framework: you can use it in other frameworks, for example, in frameworks with UI modules (view controllers).

Some code is shared between tests and app:
* **MixboxIpc**: abstraction over IPC, e.g.: "send me data".
* **MixboxBuiltinIpc**: implementation.
* **MixboxIpcCommon**: interfaces of specific IPC, e.g.: "send me percentage of visible area".


