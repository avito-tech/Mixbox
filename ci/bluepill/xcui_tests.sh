#!/bin/bash

set -x
set -o pipefail

tmpDir=/tmp/083D9EF7-033B-43C3-8D35-2273367B6F92
scriptDir=$(cd "$(dirname $0)"; pwd)

destination() {
    cat "$(destinationFile)"
}
destinationFile() {
    echo "$scriptDir/../destinations/$MIXBOX_CI_DESTINATION"
}
xcodeDestination() {
    local name=`destination | jq -r .[0].testDestination.deviceType`
    local os=`destination | jq -r .[0].testDestination.iOSVersion`
    echo "platform=iOS Simulator,name=$name,OS=$os"
}

buildForTesting() {
    echo "Building app..."
    
    derivedDataPath=$tmpDir/dd
    
    if [ "$CACHE" == "regenerate" ]
    then
        rm -rf "$derivedDataPath"
    fi
    
    mkdir -p "$derivedDataPath"
    
    xcodebuildLogPath="$derivedDataPath/xcodebuild.log.ignored"
    
    cd `dirname $0`/../../Tests
    
    if [ "$CACHE" == "use" ] && cmp Podfile.lock Pods/Manifest.lock
    then
        : # skip
    else
        pod install
    fi
    
    echo "Building for testing. Build is log path: $xcodebuildLogPath"

    xcodebuild \
        build-for-testing \
        -workspace Tests.xcworkspace \
        -scheme XcuiTests \
        -sdk iphonesimulator \
        -derivedDataPath "$derivedDataPath" \
        -destination "$(xcodeDestination)"
        > "$xcodebuildLogPath"
        
    # Work around a bug when xcodebuild puts Build and Indexes folders to a pwd instead of dd/

    [ -d "Build" ] && echo "Moving Build/ -> $derivedDataPath/" && mv -f "Build" "$derivedDataPath"
    [ -d "Index" ] && echo "Moving Index/ -> $derivedDataPath/" && mv -f "Index" "$derivedDataPath"
}

if [ "$CACHE" == "use" ]
then
    : # skip
else
    rm -rf "$tmpDir"
    mkdir -p "$tmpDir"
fi

buildForTesting

which bluepill || brew install bluepill

reportsPath="${MIXBOX_CI_REPORTS_PATH:-$tmpDir}"
mkdir -p "$reportsPath"

echo "Running tests"

cd "$scriptDir"

bluepill \
--reuse-simulator \
--headless \
--xctestrun-path "$(ls -1 "$derivedDataPath"/Build/Products/XcuiTests_iphonesimulator*.xctestrun|head -1)" \
--num-sims 2 \
--include "ActionsTests/test_tap" \
--include "ActionsTests/test_press" \
--include "ActionsTests/test_setText" \
--include "AssertingCustomValuesTests/test_equals" \
--include "IpcEchoingTests/test_0" \
--junit-output \
-o "$reportsPath/junit.xml"

if [ "$CACHE" == "use" ] || [ "$CACHE" == "regenerate" ]
then
    : # skip
else
    rm -rf "$tmpDir"
    mkdir -p "$tmpDir"
fi