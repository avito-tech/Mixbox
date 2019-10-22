## Overview

![Version](https://cocoapod-badges.herokuapp.com/v/MixboxFoundation/badge.png)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
[![Build Status](https://travis-ci.org/avito-tech/Mixbox.svg?branch=master)](https://travis-ci.org/avito-tech/Mixbox)

Powerful E2E UI testing framework for iOS.

Currently it is used in Avito, where we have 700+ E2E UI tests, about 90% of them are green and they helped us to reduce
manual testing for already 2 years. We run about 25% on PR and we are working towards executing 100% of tests on pull request, partially by switching from Black Box E2E to Gray Box testing. We are running those tests on 3 platforms and it takes ~40 minutes (total duration of tests is 30+ hours), because we are using [Emcee](https://github.com/avito-tech/Emcee), a test runner that runs tests on multiple machines (note that Mixbox doesn't require Emcee). We're writing Gray Box tests too (where we mock classes, network and everything), but we just started.

If you are enthusiastic about using it in your company, file us an issue. We are making it to be usable by community,
however, it is not our main goal.

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
    - Page object elements can nest elements (however, it requires some not-so-good looking boilreplate)
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
- Customizable without forking repository
- Swift & Objective-C
- Tested
    - 176 black box UI tests on 3 device configurations
    - 155 gray box UI tests on 3 device configurations
    - 100 unit tests on 4 device configurations
    - SwiftLint + custom linter
    - All tests are executed per every pull request to Mixbox, and usually 1 PR equals 1 commit.
    - Two demos are tested with 5 versions of Xcode (10.0, 10.1, 10.2.1, 10.3, 11.0).
- Configurable reports (e.g.: `Tests` project has integration with Allure, an open sourced reporting system with web UI,
  and in Avito we use in-house solution for reports; you can write your own implementation)

In development / not open sourced yet:

- Code generation of page objects
- Getting all assertion failures from app
- Facade for working with springboard
- Switching accessibility values between release and test builds

## Installation

There are two ways to use Mixbox.

First is described in [Demo](Demos), it is oversimplified, basically you just use `pod SomePod`.

The second we use in Avito and it looks like this: [Tests](Tests) (see Podfile there).

There are not enough docs yet, so you can try simple approach of linking Mixbox ([Demo](Demos)), but use code examples from [Tests](Tests).

## Supported iOS/Xcode/Swift versions

- Xcode 11
- Swift 5
- iOS 10.3, iOS 11.4, iOS 12.1, intermediate versions may work or may not, the mentioned versions
  are tested on CI
- Cocoapods 1.8.4
- Mac OS 10.14.6

Xcode 9/10 and older versions are not supported anymore. If you are planning to use the project on different environment and have problems, let us know.

## Known issues

- Crashes on iOS 11.2 (works ok on iOS 11.3, iOS 11.4)
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

- EarlGrey (every source file contains `EarlGrey` substring somewhere). [License is here (Apache)](Docs/EarlGreyLicense/LICENSE),
  [original repo is here](https://github.com/google/EarlGrey). It is visibility checker, setting up accessibility, etc.
- [AnyCodable](Frameworks/AnyCodable). `#if` clauses were added.

## Other docs

- [Why so many frameworks?](Docs/Frameworks.md)
- [How-To Private API](Docs/PrivateApi.md)
- [Code of conduct](CODE_OF_CONDUCT.md)
- [Setting up project to switch notification permissions](Frameworks/FakeSettingsAppMain/README.md)
