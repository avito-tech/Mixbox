#!/bin/bash

cd `dirname $0`/../Tests

pod install

xcodebuild \
    test \
    -workspace Tests.xcworkspace \
    -scheme AllTests \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=11.4'