## Overview

![Version](https://cocoapod-badges.herokuapp.com/v/MixboxFoundation/badge.png)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
[![Build Status](https://travis-ci.org/avito-tech/Mixbox.svg?branch=master)](https://travis-ci.org/avito-tech/Mixbox)

Powerful E2E UI testing framework for iOS.

Currently it is used in Avito, where we have 900+ UI tests, 95% of them are green, 10% of them are run on PR and we are working towards executing 100% of tests on pull request. We are running those tests on 3 platforms and it takes 1 hour (total duration of tests is 40+ hours), because we are using [Emcee](https://github.com/avito-tech/Emcee), a test runner that runs tests on multiple machines.

If you are enthusiastic about using it in your company, file us an issue. We are making it to be usable by community, however, it is not our main focus now.

## Other docs

- [Why so many frameworks?](Docs/Frameworks.md)
- [How-To Private API](Docs/PrivateApi.md)