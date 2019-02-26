prepareForTesting() {
    set -x
    set -e
    set -o pipefail
    
    [ -z "$MIXBOX_CI_REPORTS_PATH" ] && fatalError "\$MIXBOX_CI_REPORTS_PATH is not set"
    [ -z "$MIXBOX_CI_TEMPORARY_DIRECTORY" ] && fatalError "\$MIXBOX_CI_TEMPORARY_DIRECTORY is not set"
    
    # TODO: Bump to 1.6.1
    local cocoapodsVersion="1.5.3"
    (which pod && [ `pod --version` == "$cocoapodsVersion" ]) || gem install cocoapods -v "$cocoapodsVersion"
    
    which xcpretty || brew install xcpretty
    which jq || brew install jq

    if [ "$MIXBOX_CI_CACHE" == "use" ]
    then
        : # skip
    else
        rm -rf "$MIXBOX_CI_TEMPORARY_DIRECTORY"
        mkdir -p "$MIXBOX_CI_TEMPORARY_DIRECTORY"
    fi
    
    mkdir -p "$MIXBOX_CI_REPORTS_PATH"
}

prepareForIosTesting() {
    prepareForTesting
    
    # Improves stability of launching tests
    shutdownDevices
    setUpDeviceIfNeeded
    
    # This is done in background and prepares simulator
    bootDevice
}

prepareForMacOsTesting() {
    prepareForTesting
}