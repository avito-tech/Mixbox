buildIosWith_folder_action_scheme_workspace_xcodebuildPipeFilter() {
    local folder=$1
    local action=$2
    local scheme=$3
    local workspace=$4
    local xcodebuildPipeFilter=${5:-tee}
    local derivedDataPath=`derivedDataPath`
    
    cd "$MIXBOX_CI_REPO_ROOT/$folder"
    
    buildWith_xcodebuildPipeFilter_xcodebuildArgs "$xcodebuildPipeFilter" \
        "$action" \
        -workspace "$workspace".xcworkspace \
        -scheme "$scheme" \
        -sdk iphonesimulator \
        -derivedDataPath "$derivedDataPath" \
        -destination "$(xcodeDestination)"
}


buildMacOsWith_folder_action_scheme_workspace() {
    local folder=$1 # Tests
    local action=$2 # build-for-testing
    local scheme=$3 # XcuiTests
    local workspace=$4 # Tests
    local derivedDataPath=`derivedDataPath`
    
    cd "$MIXBOX_CI_REPO_ROOT/$folder"
    
    buildWith_xcodebuildPipeFilter_xcodebuildArgs tee \
        "$action" \
        -workspace "$workspace".xcworkspace \
        -scheme "$scheme" \
        -derivedDataPath "$derivedDataPath"
}

buildWith_xcodebuildPipeFilter_xcodebuildArgs() {
    local xcodebuildPipeFilter=$1
    shift
    local xcodebuildArgs=$@
    
    [ -z "$action" ] && fatalError "\$action is not set"
    [ -z "$scheme" ] && fatalError "\$scheme is not set"
    [ -z "$xcodebuildPipeFilter" ] && fatalError "\$xcodebuildPipeFilter is not set"
    [ -z "$MIXBOX_CI_REPO_ROOT" ] && fatalError "\$MIXBOX_CI_REPO_ROOT is not set"
    
    echo "Building using xcodebuild..."
    
    if [ "$MIXBOX_CI_CACHE" == "regenerate" ]
    then
        rm -rf "$derivedDataPath"
    fi
    
    mkdir -p "$derivedDataPath"
    
    if [ "$MIXBOX_CI_CACHE" == "use" ] && cmp Podfile.lock Pods/Manifest.lock
    then
        : # skip
    else
        pod install || pod install --repo-update
    fi
    
    echo "Building for testing. Build is log path: $xcodebuildLogPath"
    
    xcodebuild "$@" \
        | "$xcodebuildPipeFilter" \
        || fatalError "Error in xcodebuild"
        
    # Work around a bug when xcodebuild puts Build and Indexes folders to a pwd instead of dd/

    [ -d "Build" ] && echo "Moving Build/ -> $derivedDataPath/" && mv -f "Build" "$derivedDataPath" || true
    [ -d "Index" ] && echo "Moving Index/ -> $derivedDataPath/" && mv -f "Index" "$derivedDataPath" || true
}