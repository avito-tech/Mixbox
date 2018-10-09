destination() {
    cat "$(destinationFile)"
}

destinationFile() {
    [ -z "$MIXBOX_CI_DESTINATION" ] && fatalError "\$MIXBOX_CI_DESTINATION is not set"
    [ -z "$MIXBOX_CI_REPO_ROOT" ] && fatalError "\$MIXBOX_CI_REPO_ROOT is not set"
    
    echo "$MIXBOX_CI_REPO_ROOT/ci/destinations/$MIXBOX_CI_DESTINATION"
}

xcodeDestination() {
    local name=`destination | jq -r .[0].testDestination.deviceType`
    local os=`destination | jq -r .[0].testDestination.iOSVersionLong`
    echo "platform=iOS Simulator,name=$name,OS=$os"
}
