#!/bin/bash

set -ex
set -o pipefail

cd `dirname $0`/../Tests

cmp Podfile.lock Pods/Manifest.lock || pod install

which xcpretty || brew install xcpretty

xcodebuild \
test \
-workspace Tests.xcworkspace \
-scheme UnitTests \
-sdk iphonesimulator \
-destination 'platform=iOS Simulator,name=iPhone 7,OS=11.4' \
| xcpretty -r junit -o "$MIXBOX_CI_REPORTS_PATH/junit.xml"