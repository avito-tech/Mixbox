buildWith_action_scheme() {
    buildWith_action_scheme_xcodebuildPipeFilter $1 $2
}

buildWith_action_scheme_xcodebuildPipeFilter() {
    local action=$1
    local scheme=$2
    local xcodebuildPipeFilter=${3:-tee}
    
    [ -z "$action" ] && fatalError "\$action is not set"
    [ -z "$scheme" ] && fatalError "\$scheme is not set"
    [ -z "$xcodebuildPipeFilter" ] && fatalError "\$xcodebuildPipeFilter is not set"
    [ -z "$MIXBOX_CI_REPO_ROOT" ] && fatalError "\$MIXBOX_CI_REPO_ROOT is not set"
    
    echo "Building using xcodebuild..."

    local derivedDataPath=`derivedDataPath`
    
    if [ "$MIXBOX_CI_CACHE" == "regenerate" ]
    then
        rm -rf "$derivedDataPath"
    fi
    
    mkdir -p "$derivedDataPath"
    
    cd "$MIXBOX_CI_REPO_ROOT/Tests"
    
    if [ "$MIXBOX_CI_CACHE" == "use" ] && cmp Podfile.lock Pods/Manifest.lock
    then
        : # skip
    else
        pod install || pod install --repo-update
    fi
    
    echo "Building for testing. Build is log path: $xcodebuildLogPath"

    xcodebuild \
        "$action" \
        -workspace Tests.xcworkspace \
        -scheme "$scheme" \
        -sdk iphonesimulator \
        -derivedDataPath "$derivedDataPath" \
        -destination "$(xcodeDestination)" \
        | "$xcodebuildPipeFilter" \
        || fatalError "Error in xcodebuild"
        
    # Work around a bug when xcodebuild puts Build and Indexes folders to a pwd instead of dd/

    [ -d "Build" ] && echo "Moving Build/ -> $derivedDataPath/" && mv -f "Build" "$derivedDataPath"
    [ -d "Index" ] && echo "Moving Index/ -> $derivedDataPath/" && mv -f "Index" "$derivedDataPath"
}
