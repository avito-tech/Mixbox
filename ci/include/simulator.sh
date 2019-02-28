shutdownDevices() {
    xcrun simctl shutdown all
}

destinationDeviceUdid() {
    local name=`destination | jq -r .[0].testDestination.deviceType`
    local os=`destination | jq -r .[0].testDestination.iOSVersionShort`
    
    xcrun simctl list -j | jq -r ".devices.\"iOS $os\"?|map(select(.name == \"$name\"))?|.[0]?|.udid?" | perl -pe 's/null//'
}

bootDevice() {
    destinationDeviceUdid=`destinationDeviceUdid`
    
    [ -z "$destinationDeviceUdid" ] && fatalError "destinationDevice returned nothing, seems that simulator was not created automatically"

    xcrun simctl boot "$destinationDeviceUdid"
}

setUpDeviceIfNeeded() {
    destinationDeviceUdid=`destinationDeviceUdid`
    
    if [ -z "$destinationDeviceUdid" ]
    then
        local name=`destination | jq -r .[0].testDestination.deviceType`
        local deviceTypeId=`destination | jq -r .[0].testDestination.deviceTypeId`
        local runtimeId=`destination | jq -r .[0].testDestination.runtimeId`
        
        echo "Creating device $name."
        
        xcrun simctl create "$name" "$deviceTypeId" "$runtimeId"
    fi
}
