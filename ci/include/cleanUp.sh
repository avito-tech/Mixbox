cleanUpAfterIosTesting() {
    cleanUpAfterTesting
}

cleanUpAfterMacOsTesting() {
    cleanUpAfterTesting
    shutdownDevices
}

cleanUpAfterTesting() {
    if [ "$MIXBOX_CI_CACHE" == "use" ] || [ "$MIXBOX_CI_CACHE" == "regenerate" ]
    then
        : # skip
    else
        rm -rf "$MIXBOX_CI_TEMPORARY_DIRECTORY"
        mkdir -p "$MIXBOX_CI_TEMPORARY_DIRECTORY"
    fi
}