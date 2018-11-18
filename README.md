## Overview

![Version](https://cocoapod-badges.herokuapp.com/v/MixboxFoundation/badge.png)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
[![Build Status](https://travis-ci.org/avito-tech/Mixbox.svg?branch=master)](https://travis-ci.org/avito-tech/Mixbox)

Powerful E2E UI testing framework for iOS.

Currently it is used in Avito, where we have 900+ UI tests, 95% of them are green, 5% of them are run on PR and we are working towards executing 100% of tests on pull request. We are running those tests on 3 platforms and it takes 1 hour (total duration of tests is 40+ hours), because we are using [Emcee](https://github.com/avito-tech/Emcee), a test runner that runs tests on multiple machines.

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
- Everything can be disabled
- Swift & Objective-C
- Tested (not thoroughly though)

Coming soon (is not open sourced yet):
- Code generation of page objects
- Getting all assertion failures from app
- Facade for working with springboard
- Reports (including Allure, an open sourced reporting system with web UI)
- Switching accessibility values between release and test builds

## Supported iOS/Xcode/Swift versions

- Xcode 9, Xcode 10
- Swift 4.1, Swift 4.2
- iOS 9.3.2, iOS 10.3, iOS 11.3, iOS 11.4, iOS 12.0, intermediate versions may work or may not, the mentioned versions are tested on CI

## Known issues

- Crashes on iOS 11.2 (works ok on iOS 11.3, iOS 11.4)
- Setting permissions doesn't work on physical devices (and maybe something else, we don't test on physical devices; basic things work)
- Device rotation was not tested, I think we have bugs with it
- iPads were not tested

## Other docs

- [Why so many frameworks?](Docs/Frameworks.md)
- [How-To Private API](Docs/PrivateApi.md)