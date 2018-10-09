#!/bin/bash

set -ex
set -o pipefail

tmpDir=/tmp/EAF744B8-3A57-473C-95E9-B1A7B7FA1BDD
scriptDir=$(cd "$(dirname $0)"; pwd)

rm -rf "$tmpDir"
mkdir -p "$tmpDir"
derivedDataPath=$tmpDir/dd

cd `dirname $0`/../Tests

cmp Podfile.lock Pods/Manifest.lock || pod install

which xcpretty || brew install xcpretty
which jq || brew install jq

destination() {
    cat "$(destinationFile)"
}

destinationFile() {
    echo "$scriptDir/destinations/$MIXBOX_CI_DESTINATION"
}

xcodeDestination() {
    local name=`destination | jq -r .[0].testDestination.deviceType`
    local os=`destination | jq -r .[0].testDestination.iOSVersion`
    echo "platform=iOS Simulator,name=$name,OS=$os"
}

xcodebuild \
test \
-workspace Tests.xcworkspace \
-scheme UnitTests \
-sdk iphonesimulator \
-derivedDataPath "$derivedDataPath" \
-destination "$(xcodeDestination)" \
| xcpretty -r junit -o "$MIXBOX_CI_REPORTS_PATH/junit.xml"