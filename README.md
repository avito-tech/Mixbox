## Overview

![Version](https://cocoapod-badges.herokuapp.com/v/MixboxFoundation/badge.png)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
[![Build Status](https://travis-ci.org/avito-tech/Mixbox.svg?branch=master)](https://travis-ci.org/avito-tech/Mixbox)

Powerful E2E UI testing framework for iOS.

Currently it is used in Avito, where we have 900+ UI tests, 95% of them are green, 25% of them we run on PR and we are working towards executing 100% of tests on pull request. We are running those tests on 3 platforms and it takes 1.5 hours (total duration of tests is 55+ hours), because we are using [Emcee](https://github.com/avito-tech/Emcee), a test runner that runs tests on multiple machines (note that Mixbox doesn't reuquired Emcee).

If you are enthusiastic about using it in your company, file us an issue. We are making it to be usable by community, however, it is not our main focus now. Our main focus is on making 100% stable suite.

## Features

- Actions and checks (obviously)
- Per-pixel visibility check
- Every check has polling
- Fully automatic scrolling
- Every cell inside UICollectionView is visible in tests (including offscreen cells)
- Customizable inter-process communication between app and tests
- Custom values for views that are visible in tests
- Page Objects
- Network mocking (via NSURLSessionProtocol)
- Setting permissions (camera/geolocation/notifications/etc)
- Simulation of push-notifications (limitations: only inside active app!)
- Opening url from tests
- Geolocation simulation
- Hardware keyboard (very few key codes are defined, however it can be easily implemented)
- Customizable without forking repository
- Swift & Objective-C
- Tested: 180 UI tests & 70 unit tests on 4 platforms that are run per every pull request to Mixbox

Coming soon (in development / is not open sourced yet):
- Gray box testing - execute UI tests inside application process with access to its memory.
- Code generation of page objects
- Getting all assertion failures from app
- Facade for working with springboard
- Reports (including Allure, an open sourced reporting system with web UI)
- Switching accessibility values between release and test builds

## Installation

There are two ways to use Mixbox.

First is described in [Demo](Demos), it is oversimplified, basically you just use `pod SomePod`.

The second we use in Avito and it looks like this: [Tests](Tests) (see Podfile there).

There are not enough docs yet, so you can try simple approach of linking Mixbox ([Demo](Demos)), but use code examples from [Tests](Tests).

## Supported iOS/Xcode/Swift versions

- Xcode 10.0, 10.1, 10.2.1.
- Swift 4.0+
- iOS 9.3.2, iOS 10.3, iOS 11.3, iOS 11.4, iOS 12.0, intermediate versions may work or may not, the mentioned versions are tested on CI

Xcode 9 and older versions are not supported anymore. Also we don't know if it works on Xcode 10.2.0, it is not tested on our CI.

## Known issues

- Crashes on iOS 11.2 (works ok on iOS 11.3, iOS 11.4)
- Setting permissions doesn't work on physical devices (and maybe something else, we don't test on physical devices; basic things work)
- Device rotation was not tested, I think we have bugs with it
- iPads were not tested
- Russian language in reports (will be fixed soon)

# Examples

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

This library includes some code copypasted from other libraries. Sometimes it is a single file, some times it is because we need conditional compilation built in in sources to prevent linking the code in release builds.

- EarlGrey (every source file contains `EarlGrey` substring somewhere). [License is here (Apache)](Docs/EarlGreyLicense/LICENSE). It is visibility checker, setting up accessibility, etc.
- [AnyCodable](Frameworks/AnyCodable). `#if` clauses were added.

## Other docs

- [Why so many frameworks?](Docs/Frameworks.md)
- [How-To Private API](Docs/PrivateApi.md)
