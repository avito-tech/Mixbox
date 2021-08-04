## Overview

![Version](https://cocoapod-badges.herokuapp.com/v/MixboxFoundation/badge.png)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

Powerful E2E UI testing framework for iOS.

Currently it is mostly used in [Avito](https://avito.ru), where we have about 700 black box E2E UI tests, about 1.3K non-E2E gray box UI tests, about 2K unit tests for a main application. All of them can be run successfully on pull requests.

We also like to recommend [Emcee](https://github.com/avito-tech/Emcee) that helps us to run tens of hours of tests within tens of minutes of real time. It's a test runner that distributes jobs to a pool of agents (e.g. mac mini's). Note that Emcee and Mixbox are independent of each other.

We recommend you to try it if you are enthusiastic about using it in your company. We are making it to be usable by community, however, it is not our main goal. Mixbox is used few other companies as far as we know, with almost no questions about how to use it, despite lack of documentation. 

The document is actual as of 2021.08.04.

## Features

- Black box, gray box, white box testing
  
    - Almost 100% UI testing features are available for black box testing (you start the app and tests work with it) and for gray box testing (your tests show your UI component and test it within same process). Code is runtime compatible, meaning that you can share your code or extensions to Mixbox in a single library and it will work in all your tests.
    - Some features are specific for black box or gray box testing, for example, you can't start an app in gray box tests (those tests are running within the app).

- Easily customizable

    - Custom UI actions or checks. See `ElementInteraction`.
    - Custom IPC methods (for example, if you want to pass data between your tests and app). See `IpcMethodHandler` and `InAppServices`.
    - Custom UI elements with their own methods (which all are handy aliases for low level code), see usages of `BaseElementWithDefaultInitializer`.
    - All those things would work for both black box and gray box testing without you thinking about it. They all use abstractions. Custom page objects also can be shared between those tests.
  
- Highly customizable
  
    - Everything in DI can be redefined. DI is used (almost) everywhere. The objects are instantiated in DI containers that you can alter or in factories, and you can inject different factories.
    - We may lack support of SPM or Carthage (so you may want to fork it), but we built Mixbox with this requirement in mind: it should not require you to fork it. Please, send your pull requests if you fork Mixbox.
    - Also everything can be disabled. There is no code that is running unless you said so (e.g. no `+(void)load` and such things).

- Working with UI
  
  - Actions and checks have per-pixel visibility check. If user can see it, tests can to. If user can not see it, test can not see it too.
  - Everything has polling.
  - Fully automatic scrolling.
  - Everything above can be customized or disabled per action or per page object element.
  - Every cell inside UICollectionView is accessible in tests (including offscreen cells). This feature has little side effects. This is not implemented for UITableView. See `UICollectionViewCell+Testability.swift` about overcoming side effects (e.g. might happen if use singleton in a cell or your cell lifecycle creates side effects; those can be handled anyway).

- Actions
  
  - Tapping
  - Pressing
  - Swiping/dragging (with different options)  
  - Setting text (with different options)
  - Your custom actions that inherit from `ElementInteraction` can use tools that work for black box and gray box tests. 
  - Note: it is not easy to add custom gestures, see Limitations.
  
- Checks, matchers and locators

  - Checks are made using matchers. Matchers can match 17 properties of element, not including nested properties. Examples:

    ```swift
    pageObjects.myPageObject.myView.item(at: 0).title.assertMatches {
        $0.frame.size.height.isLessThan(oneLineLabelMaxHeight)
    }
    ```
    
  - Same matchers are used in page object element locators:
    ```swift
    pageObjects.searchResults.categoryWidget.item(at: 0).title.assertMatches {
        $0.frame.size.height.isLessThan(oneLineLabelMaxHeight)
    }
    ```

  - There is a native support of custom values of an object. In application you can set a value and read it from tests. They are typed, so you can do this (example code):
  
    ```swift
    public var mySwitch: ViewElement {
        return element("свитчер пушей для Новости") { element in
            element.type == .switch && element.isSubviewOf { element in
                element.id == "sectionItemavito_newspush"
            }
        }
    }
    ```
    
  - See `ElementMatcherBuilder` for all options.

- Network mocking (via NSURLSessionProtocol)
- Setting permissions (camera/geolocation/notifications/etc; 24 different kinds of services in total)
- Simulation of push-notifications (limitations: only inside active app!)
- Opening url from tests
- Geolocation simulation
- Generation of random data for tests with little boilerplate. See `MixboxGenerators`.
- Supports Swift & Objective-C apps (custom values of views are only avaliable for Swift apps)
- Supports Swift (only) in tests
- Doesn't leak code in your release builds
  - There are several levels of defence against it.
  - There is a trick in Mixbox that notifies you if you do it at the linking stage.
  - All code is under conditional compilation flag `MIXBOX_ENABLE_IN_APP_SERVICES`.
  - Exception! `MixboxTestability` has little dummy code in release configuration, but you can not link it in release builds). See demo projects.
  - You can simply not link anything in your release configuration. This actually have to be done if you ae not using any optimization/merging technology (amimono for cocoapods or SPM), because empty frameworks add a little overhead.
  - `MIXBOX_ENABLE_IN_APP_SERVICES` is in every framework that should be linked in an app, it is verified by a CI build (we can't merge commit into a main branch that violates this rule).
  - Note that frameworks that are purely for tests do not have it, don't link them in your app!
- Well tested
  - 221 black box UI tests on 4 device configurations
  - 204 gray box UI tests on 4 device configurations
  - 446 white box (unit) tests on 4 device configurations
  - SwiftLint + custom linter
  - All tests are executed per every pull request to Mixbox, and usually 1 PR equals 1 commit.
- Is regularly released to Cocoapods, it's a main method of distribution for our in-house projects.

# Limitations

Known issues

- !!! Russian language in reports !!! (we are slowly rewriting it in English, we decided that we won't do internationalization and will just use English; it's not done yet)
- Crashes on iOS 11.2 (works ok on iOS 11.3, iOS 11.4)
- Setting permissions doesn't work on physical devices (and maybe something else, we don't test on physical devices;
  basic things work)
- Device rotation was not tested, may not be working
- iPads were not tested

Lack of support of proper customization (PRs welcome).

- Unfortunately, we didn't made it easy to add custom UI gestures. Touch event generation code exists for both types of tests, but separately, not under an easy abstraction. So, ideally, this requires contributing to Mixbox, but this is not a requirement (theoretically you can implement it without forking Mixbox, but that would be not easy).
- Configurable reports (is not represented in Demo; there are a lot of useful reports out of the box, but you have to connect it to your reporting system)
- Hardware keyboard (very few key codes are defined inside Mixbox, though, something like cmd, C, V, A, used for copy-pasting text)
- Getting all assertion failures from app (see `GetRecordedAssertionFailuresIpcMethod`, you have to set it up yourself)

In development / not open sourced yet:

- Code generation of page objects
- Code generation of mocks (a very simple code is used in `Tests` project, but in Avito we use our own code generation that is fast and simple to use (just annotate the class and you're good to go); there are no plans to convert it to open source code)
- Code generation for `MixboxGenerators` is not open sourced in any form. So you have to write a little boilerplate for it (1 line per field of the type + little constant overhead). If we open sourced code generation, there will be purely zero boilerplate.
  
## What's black box and gray box testing?

Black box tests and app are run in a separate processes. Tests launching the app and testing it, the app is "black box" (however, both Mixbox and Apple UI tests use IPC for obtaining information about the app, such as hierarchy of elements). You can test more application features with this type of testing. You can use mocks, but it will require you to write more code (use launch arguments or implement inter-process communication).

Gray box tests are run within the application. It is like in the [EarlGrey](https://github.com/google/EarlGrey)), but tests are **runtime compatible** with black box tests, so you can share your test model, page objects, test helpers, etc. You can mock easily anything, because test are executed within same process. You can't test starting your app up without using mocks.
    
Most of the code is shared between gray box and black box tests, as the most of the features. Both options have their own benefits. Use both approaches to have a good [test pyramid](https://martinfowler.com/bliki/TestPyramid.html).

## Installation

See [Demo](Demos/UiTestsDemo), it is beyond simple, though. It shows how to get a minimal setup, but lacks demo of most of the features.

The [Tests](Tests) project has all the features, but it's not how we use Mixbox.

There are not enough docs yet, so you can try simple approach of linking Mixbox ([Demo](Demos/OsxIpcDemo)), but use code examples from [Tests](Tests). You can also read code.

## Supported iOS/Xcode/Swift versions

- Xcode 12.5
- Swift 5
- iOS 11.4, iOS 12.4, iOS 13.7, iOS 14.1, intermediate versions may work or may not, the mentioned versions are tested on CI. It probably works on iOS 10.3, we just don't test on it, because we don't support this version.

Xcode 9/10 and older versions are not supported anymore. We don't know if it works on them.

# Examples

For real examples, see `Tests` project. It is most up-to-date open sourced examples of how to use it, but it lacks realism (doesn't show it how to tests are written for a real app).

Example of test that show basic features (black box tests):

```swift
func test() {
    // Setting permissions
    permissions.camera.set(.allowed)
    permissions.photos.set(.notDetermined)

    // Functions are useful in page objects and allows
    // reusing code, for example, for transitions between states of the app.
    // The following functions are custom.
    pageObjects.initial
        .authorize(user: testUser)
        .goToCvScreen()
        
    // Aliases for simple assertions.
    // You can add your own: you can extend existing classes/protocols or add your own.
    pageObjects.simpleCv.view.assertIsDisplayed()
    pageObjects.simpleCv.title.assertHasText("My CV")
    
    // Fully customizable assertions.
    //
    // There are matchers for strings like isEmpty, isNotEmpty, for regular expressions, etc.
    // For Equatable or Comparable objects (==, <, >, <=, =>).
    // `isClose` for floats.
    // You can write your extensions.
    // See `MappingMatcherBuilder`. 
    //
    // See also `ElementMatcherBuilder` for DSL for UI elements. Also, if you want
    // such DSL for your own types, see `DynamicMatcherBuilder`.
    pageObjects.simpleCv.addressField.assertMatches { element in
        element.text != addressFieldInitialText && element.text.isNotEmpty()
    }
    
    // Network stubbing.
    networking.stubbing
        .stub(urlPattern: ".*?example.com/api/cv")
        .thenReturn(file: "cv.json")
    // There is also a monitoring feature, including recording+replaying feature that
    // allows to record all network and replay in later, so your tests will not require internet.
    
    // Actions
    pageObjects.simpleCV.occupationField.setText("iOS developer")
    pageObjects.simpleCV.createCVButton.tap()
}
```

Example that also shows data generation (`MixboxGenerators`):

Only relevant fields are defined, other are filled automatically.

```swift
  func test___vacancy_snippet___shopTitle___is_displayed() {
      openAdvertisement {
          $0.sellerInfo = $0.generate {
              $0.name = "Work here"
          }
      }
      
      advertisement.shopTitle.assertHasText("Work here")
  }
  
  func test___vacancy_snippet___sellerAvatar___is_displayed() {
      openAdvertisement {
          $0.sellerInfo = $0.generate {
              $0.avatar = $0.some()
          }
      }
      
      advertisement.sellerAvatar.assertIsDisplayed()
  }
```

Example that also shows verification in mocks (`MixboxMocksRuntime`):

```swift
// Method `updateSomething` can have many parameters that can be omitted in verification
// They are matched with `any()` by default.
somethingSomethingUpdatingService
    .verify()
    .updateSomething(
        something: equals(["foo", "bar"]),
    )
    .isCalled()
```

Note that stubbing of mocks is automatic (including asynchronous calls), unless it is customized as shown here:

```swift
pushService
    .stub()
    .delegate
    .get()
    .thenReturn(delegate)

pushService
    .stub()
    .pushNotificationsStatus()
    .thenCall
    .completion(.allowed)
```

Declaring page objects:

```
public final class MapScreen:
    BasePageObjectWithDefaultInitializer,
    ScreenWithNavigationBar // protocol extensions are very useful for sharing code
{
    // Basic locator  
    public var mapView: ViewElement {
        return element("Map view") { element in
            element.id == "GoogleMapView"
        }
    }
    
    // You can use complex checks
    // Note that you can create your own matchers like `element.isFooBar()`
    public func pin(coordinates: Coordinates, deltaInMeters: Double = 10) -> ViewElement {
        return element("Pin with coordinates \(coordinates)") { element in
            element.id == "pin" && element
                .customValues["coordinates", Coordinates.self]
                .isClose(to: coordinates, deltaInMeters: deltaInMeters)
        }
    }
}
```

Declaring custom page object elements:

```
public final class RatingStarsElement:
    BaseElementWithDefaultInitializer,
    ElementWithUi
{
    public func assertRatingEqualsTo(
        _ number: Int,
        file: StaticString = #file,
        line: UInt = #line)
    {
        assertMatches(file: file, line: line) { element in
            element.customValues["rating"] == number
        }
    }
}
```

## Copypasted code

This library includes some code copypasted from other libraries. Sometimes it is a single file, some times it is because we need conditional compilation built in sources to prevent linking the code in release builds (`MIXBOX_ENABLE_IN_APP_SERVICES` flag).

- **EarlGrey** (every source file that used `EarlGrey` contains `EarlGrey` substring somewhere). [License is here (Apache)](Docs/EarlGreyLicense/LICENSE). It is visibility checker, setting up accessibility, etc. **Original repo:** <https://github.com/google/EarlGrey>
- [**AnyCodable**](Frameworks/AnyCodable). `#if` clauses were added. **Original repo:** <https://github.com/Flight-School/AnyCodable>
- **SBTUITestTunnel**. There was a bug with web views with versions newer than 3.0.6. Then several years later we experienced flakiness when building it. The fix was very primitive - copypaste everything to avoid problems. We could have dive deeper, but there is a plan to use native solution for IPC in the future, so we didn't bother. **Original repo:** <https://github.com/Subito-it/SBTUITestTunnel>
- [**CocoaImageHashing**](Frameworks/CocoaImageHashing). We needed a fix that can't be merged due to backward compatibility (<https://github.com/ameingast/cocoaimagehashing/pull/13>), we don't need backward compatibility, so we use copypasted code. **Original repo:** <https://github.com/ameingast/cocoaimagehashing>

Used in tests:

- <https://github.com/akveo/eva-icons>: various icons for testing image similarity code (MIT licence).

## Other docs

- [Why so many frameworks?](Docs/Frameworks.md)
- [How-To Private API](Docs/PrivateApi.md)
- [Code of conduct](CODE_OF_CONDUCT.md)
- [Contributing](CONTRIBUTING.md)
- [Setting up project to switch notification permissions](Frameworks/FakeSettingsAppMain/README.md)
