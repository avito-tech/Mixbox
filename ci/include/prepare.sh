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
    
    # Improves stability of launching tests
    shutdownDevices
    
    setUpDeviceIfNeeded
    
    # This is done in background and prepares simulator
    bootDevice
    
    mkdir -p "$MIXBOX_CI_REPORTS_PATH"
}
