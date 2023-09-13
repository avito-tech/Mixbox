## Overview

![Version](https://cocoapod-badges.herokuapp.com/v/MixboxFoundation/badge.png)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
[![Build Status](https://travis-ci.org/avito-tech/Mixbox.svg?branch=master)](https://travis-ci.org/avito-tech/Mixbox)

Powerful E2E UI testing framework for iOS.

Currently it is used in Avito, where we have 700+ E2E UI tests (called black box tests in Mixbox), 3900+ gray box tests 
that are more atomic and check single things on single screens and are very fast (last 6 seconds on average).
We like to recommend [Emcee](https://github.com/avito-tech/Emcee),
a test runner that runs tests on multiple machines (note that Mixbox doesn't require Emcee and vice versa), it
allows us to run 10 hours of tests on PR in just 20 minutes or so (we have about 30-50 pull requests a day), we have about 150 apple machines.

We made Mixbox to be usable by community, however, it is not our main goal. If you don't understand something, file us an issue.

## Features

- Actions and checks (obviously)
- Per-pixel visibility check
- Everything has polling
- Fully automatic scrolling
- Black box AND gray box testing!
    - Black box tests are run in a separate app and are able to launch app. You can test more application features with
      this type of testing. You can use mocks, but it will require you to write more code (use launch arguments or 
      implement inter-process communication).
    - Gray box tests are run within the application (as in [EarlGrey](https://github.com/google/EarlGrey)), but tests 
      are **runtime compatible** with black box tests, so you can share your test model, page objects, test helpers,
      etc. You can mock easily anything, because test are executed within same process. You can't test starting your app 
      up without using mocks.
    
    Most of the code is shared between gray box and black box tests, as the most of the features. Both options have
    their own benefits. Use both approaches to have a good [test pyramid](https://martinfowler.com/bliki/TestPyramid.html).
    
- Page Objects
    - Can have functions with any code inside
    - Page object elements can nest elements (however, it requires some not-so-good looking boilerplate)
    - Everything (actions/checks) is fully extensible. If you implement custom action or check, it will automatically
      work for black box and gray box testing (see `SwipeAction`, all builtin actions are really extensions).
    
- Every cell inside UICollectionView is visible in tests (including offscreen cells)
- Customizable inter-process communication between app and tests
- Custom values for views that are visible in tests
- Network mocking (via NSURLSessionProtocol)
- Setting permissions (camera/geolocation/notifications/etc)
- Simulation of push-notifications (limitations: only inside active app!)
- Opening url from tests
- Geolocation simulation
- Hardware keyboard (very few key codes are defined, however it can be easily implemented)
- Customizable without forking repository (except when you have SPM, SPM is not supported and people made forks for that),
  because everything can be injected via DI and override builtin functionality. Nothing is executed automatically either
  (i.e. in +(void)load methods), so you have full control of what is executed and when.
- Tested (stats as of September 2023)
    - 236 black box, 241 gray box, 462 unit tests are run on all supported iOS versions
    - SwiftLint + custom linter
    - All tests are executed per every pull request to Mixbox, and usually 1 PR equals 1 commit.
- Configurable reports (e.g.: `Tests` project has integration with Allure, an open sourced reporting system with web UI,
  and in Avito we use in-house solution for reports; you can write your own implementation)

## Installation

There are two ways to use Mixbox.

First is described in [Demo](Demos), it is oversimplified, basically you just use `pod SomePod`.

The second we use in Avito and it looks like this: [Tests](Tests) (see Podfile there).

There are not enough docs yet, so you can try simple approach of linking Mixbox ([Demo](Demos)), but use code examples from [Tests](Tests).

## Known issues

- Setting permissions doesn't work on physical devices (and maybe something else, we don't test on physical devices;
  basic things work)
- Device rotation was not tested, I think we have bugs with it
- iPads were not tested
- Russian language in reports (will be fixed soon)

# Examples

For real examples, see `Tests` project. It is most up-to-date open sourced examples of how to use it, but it lacks realism (doesn't show it how to tests are written for a real app).

Example of test that show basic features:

```
func test() {
    // Setting permissions
    permissions.camera.set(.allowed)
    permissions.photos.set(.notDetermined)

    // Functions are useful in page objects and allows
    // reusing code, for example, for transitions between states of the app
    pageObjects.initial
        .authorize(user: testUser)
        .goToCvScreen()
        
    // Aliases for simple assertions (you can add your own):
    pageObjects.simpleCv.view.assertIsDisplayed()
    pageObjects.simpleCv.title.assertHasText("My CV")
    
    // Fully customizable assertions
    pageObjects.simpleCv.addressField.assertMatches { element in
        element.text != addressFieldInitialText && element.text.isNotEmpty
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

This library includes some code copypasted from other libraries. Sometimes it is a single file, some times it is because
we need conditional compilation built in in sources to prevent linking the code in release builds.

- **EarlGrey** (every source file that used `EarlGrey` contains `EarlGrey` substring somewhere). [License is here (Apache)](Docs/EarlGreyLicense/LICENSE). It is visibility checker, setting up accessibility, etc. **Original repo:** <https://github.com/google/EarlGrey>
- [**AnyCodable**](Frameworks/AnyCodable). `#if` clauses were added. **Original repo:** <https://github.com/Flight-School/AnyCodable>
- **SBTUITestTunnel**. There was a bug with web views with versions newer than 3.0.6. Then several years later we experienced flakiness when building it. The fix was very primitive - copypaste everything to avoid problems. We could have dive deeper, but there is a plan to use native solution for IPC in the future, so we didn't bother. **Original repo:** <https://github.com/Subito-it/SBTUITestTunnel>
- [**CocoaImageHashing**](Frameworks/CocoaImageHashing). We needed a fix that can't be merged due to backward compatibility (<https://github.com/ameingast/cocoaimagehashing/pull/13>), we don't need backward compatibility, so we use copypasted code. **Original repo:** <https://github.com/ameingast/cocoaimagehashing>

Used in tests:

- <https://github.com/akveo/eva-icons>: various icons for testing image similarity code (MIT licence).

## Other docs

- [Changelog](CHANGELOG.md)
- [Why so many frameworks?](Docs/Frameworks.md)
- [How-To Private API](Docs/PrivateApi.md)
- [Code of conduct](CODE_OF_CONDUCT.md)
- [Contributing](CONTRIBUTING.md)
- [Setting up project to switch notification permissions](Frameworks/FakeSettingsAppMain/README.md)
