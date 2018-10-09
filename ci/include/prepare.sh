prepareForTesting() {
    [ -z "$MIXBOX_CI_REPORTS_PATH" ] && fatalError "\$MIXBOX_CI_REPORTS_PATH is not set"
    [ -z "$MIXBOX_CI_TEMPORARY_DIRECTORY" ] && fatalError "\$MIXBOX_CI_TEMPORARY_DIRECTORY is not set"
    
    set -x
    set -o pipefail
    
    which xcpretty || brew install xcpretty
    which jq || brew install jq

    if [ "$MIXBOX_CI_CACHE" == "use" ]
    then
        : # skip
    else
        rm -rf "$MIXBOX_CI_TEMPORARY_DIRECTORY"
        mkdir -p "$MIXBOX_CI_TEMPORARY_DIRECTORY"
    fi
    
    setUpDeviceIfNeeded
    
    mkdir -p "$MIXBOX_CI_REPORTS_PATH"
}

setUpDeviceIfNeeded() {
    local name=`destination | jq -r .[0].testDestination.deviceType`
    local os=`destination | jq -r .[0].testDestination.iOSVersionShort`
        
    if ! xcrun simctl list -j|jq -e ".devices.\"iOS $os\"?|.[]?|select(.name == \"$name\")" 1>/dev/null
    then
        echo "Creating device $name."
        
        local deviceTypeId=`destination | jq -r .[0].testDestination.deviceTypeId`
        local runtimeId=`destination | jq -r .[0].testDestination.runtimeId`
        
        xcrun simctl create "$name" "$deviceTypeId" "$runtimeId"
    fi
}
