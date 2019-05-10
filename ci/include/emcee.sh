installEmceeWithDependencies() {
    installLibssh
    installEmcee
}

installLibssh() {    
    brew ls --versions libssh2 > /dev/null || brew install libssh2
}

__MIXBOX_CI_EMCEE_PATH=
installEmcee() {
    echo "Installing Emcee..."
    
    if [ "$MIXBOX_CI_EMCEE_URL" ]
    then
        __MIXBOX_CI_EMCEE_PATH=`download "$MIXBOX_CI_EMCEE_URL"`
        
        chmod +x "$__MIXBOX_CI_EMCEE_PATH"
    else
        __MIXBOX_CI_EMCEE_PATH=`ls -1 "$MIXBOX_CI_TEMPORARY_DIRECTORY"/Emcee/.build/x86_64-*/debug/AvitoRunner|head -1` || true
    
        if [ -e "$__MIXBOX_CI_EMCEE_PATH" ]
        then
            : # skip
        else
            cd "$MIXBOX_CI_TEMPORARY_DIRECTORY"
            
            git clone https://github.com/avito-tech/Emcee
            cd Emcee
            
            local emceeVersion="25b6a7662a69d2965eee26010d69468ac86ccfde"
            git checkout "$emceeVersion"
            
            make build
            
            __MIXBOX_CI_EMCEE_PATH=`ls -1 "$MIXBOX_CI_TEMPORARY_DIRECTORY"/Emcee/.build/x86_64-*/debug/AvitoRunner|head -1`
        fi
    fi
        
    
    [ -x "$__MIXBOX_CI_EMCEE_PATH" ] || fatalError "Failed to install Emcee"
}

emcee() {
    "$__MIXBOX_CI_EMCEE_PATH" "$@"
}

testUsingEmceeWith_appName_testsTarget_additionalApp() {
    local appName=$1
    local testsTarget=$2
    local additionalApp=$3
    local runnerAppName=$testsTarget-Runner.app
    local derivedDataPath=`derivedDataPath`
    
    [ -z "$MIXBOX_CI_EMCEE_FBXCTEST_URL" ] && fatalError "\$MIXBOX_CI_EMCEE_FBXCTEST_URL is not set"

    mkdir -p "$MIXBOX_CI_REPORTS_PATH"

    echo "Running tests"

    cd "$MIXBOX_CI_SCRIPT_DIRECTORY"
    
    local emceeAction=
    local emceeArgs=()

    local destinationFile="$(destinationFile)"
    local xctestBundle="$derivedDataPath/Build/Products/Debug-iphonesimulator/$testsTarget-Runner.app/PlugIns/$testsTarget.xctest"
    local runnerPath="$derivedDataPath/Build/Products/Debug-iphonesimulator/$testsTarget-Runner.app"
    local appPath="$derivedDataPath/Build/Products/Debug-iphonesimulator/$appName"
    local additionalAppPath="$derivedDataPath/Build/Products/Debug-iphonesimulator/$additionalApp"
    
    if isDistRun
    then
        emceeAction=runTestsOnRemoteQueue
        
        # Simple args
        emceeArgs=("${emceeArgs[@]}" --priority "500")
        emceeArgs=("${emceeArgs[@]}" --run-id "$(uuidgen)")
        
        # Configs
        emceeArgs=("${emceeArgs[@]}" --destinations "$(download $MIXBOX_CI_EMCEE_WORKER_DEPLOYMENT_DESTINATIONS_URL)")
        emceeArgs=("${emceeArgs[@]}" --test-arg-file "$(testArgsFile)")
        emceeArgs=("${emceeArgs[@]}" --queue-server-destination "$(download $MIXBOX_CI_EMCEE_SHARED_QUEUE_DEPLOYMENT_DESTINATIONS_URL)")
        emceeArgs=("${emceeArgs[@]}" --queue-server-run-configuration-location "$MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL")
        
        # Tested code
        emceeArgs=("${emceeArgs[@]}" --runner "$(upload_hashed_zipped_for_emcee "$runnerPath")")
        emceeArgs=("${emceeArgs[@]}" --app "$(upload_hashed_zipped_for_emcee "$appPath")")
        emceeArgs=("${emceeArgs[@]}" --additional-app "$(upload_hashed_zipped_for_emcee "$additionalAppPath")")
        emceeArgs=("${emceeArgs[@]}" --xctest-bundle "$(upload_hashed_zipped_for_emcee "$xctestBundle")")
    else
        [ -z "$MIXBOX_CI_EMCEE_FBSIMCTL_URL" ] && fatalError "\$MIXBOX_CI_EMCEE_FBSIMCTL_URL is not set"
    
        emceeAction=runTests
        
        # Simple args
        emceeArgs=("${emceeArgs[@]}" --number-of-simulators "2")
        emceeArgs=("${emceeArgs[@]}" --schedule-strategy "progressive")
        emceeArgs=("${emceeArgs[@]}" --temp-folder "$derivedDataPath")
        emceeArgs=("${emceeArgs[@]}" --environment "$(environment)")
        emceeArgs=("${emceeArgs[@]}" --number-of-retries "3")
        emceeArgs=("${emceeArgs[@]}" --single-test-timeout "1200")
        emceeArgs=("${emceeArgs[@]}" --fbxctest-bundle-ready-timeout "600")
        emceeArgs=("${emceeArgs[@]}" --fbxctest-crash-check-timeout "600")
        emceeArgs=("${emceeArgs[@]}" --fbxctest-fast-timeout "600")
        emceeArgs=("${emceeArgs[@]}" --fbxctest-regular-timeout "600")
        emceeArgs=("${emceeArgs[@]}" --fbxctest-silence-timeout "600")
        emceeArgs=("${emceeArgs[@]}" --fbxctest-slow-timeout "1200")
        
        # Dependencies
        emceeArgs=("${emceeArgs[@]}" --fbsimctl "$MIXBOX_CI_EMCEE_FBSIMCTL_URL")
        
        # Tested code
        emceeArgs=("${emceeArgs[@]}" --runner "$runnerPath")
        emceeArgs=("${emceeArgs[@]}" --app "$appPath")
        emceeArgs=("${emceeArgs[@]}" --xctest-bundle "$xctestBundle")
    fi
    
    # Common
    emceeArgs=("${emceeArgs[@]}" --fbxctest "$MIXBOX_CI_EMCEE_FBXCTEST_URL")
    emceeArgs=("${emceeArgs[@]}" --junit "$MIXBOX_CI_REPORTS_PATH/junit.xml")
    emceeArgs=("${emceeArgs[@]}" --trace "$MIXBOX_CI_REPORTS_PATH/trace.combined.json")
    emceeArgs=("${emceeArgs[@]}" --test-destinations "$destinationFile")
    
    emcee "$emceeAction" "${emceeArgs[@]}"
}

isDistRun() {
    ! [ -z "$MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL" ] \
        && ! [ -z "$MIXBOX_CI_EMCEE_SHARED_QUEUE_DEPLOYMENT_DESTINATIONS_URL" ] \
        && ! [ -z "$MIXBOX_CI_EMCEE_WORKER_DEPLOYMENT_DESTINATIONS_URL" ]
}

testArgsFile() {
    local derivedDataPath=$(derivedDataPath)
    local runtimeDump="$derivedDataPath/runtime_dump.json"
    local destinationFile="$(destinationFile)"
    
    emcee dump \
        --test-destinations "$destinationFile" \
        --fbxctest "$MIXBOX_CI_EMCEE_FBXCTEST_URL" \
        --xctest-bundle "$xctestBundle" \
        --output "$runtimeDump" >/dev/null
    
    local testArgsFile="$derivedDataPath/test_args_file.json"
    
    jq -s '{
        entries: [
            {
                runtimeDumpJson: .[0],
                destinationsJson: .[1][].testDestination,
                environment: .[2]
            } |
            {
                testToRun: .runtimeDumpJson[] | {c: .className, m: .testMethods[]} | join("/"),
                testDestination: {
                    deviceType: .destinationsJson.deviceType,
                    runtime: .destinationsJson.iOSVersion
                },
                numberOfRetries: 4,
                environment: .environment
            }
        ]
    }' "$runtimeDump" "$destinationFile" "$(environment)" > "$testArgsFile";
    
    echo "$testArgsFile"
}

environment() {
    local derivedDataPath=`derivedDataPath`
    local sourceEnvironment="$MIXBOX_CI_SCRIPT_DIRECTORY/emcee/environment.json"
    local environment="$derivedDataPath/environment.json"

    if [ -z "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY" ] || isDistRun
    then
        cp "$sourceEnvironment" "$environment" > /dev/null
    else
        rm -rf "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY" > /dev/null
        mkdir -p "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY" > /dev/null

        cat "$sourceEnvironment" \
            | jq '. + {
                "MIXBOX_CI_ALLURE_REPORTS_DIRECTORY": "'"$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY"'"
            }' > "$environment"
    fi
    
    echo "$environment"
}

generateReports() {
    if ! [ -z "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY" ]
    then
        which allure || brew install allure

        local results="$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY/results"
        local report="$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY/report"
        
        allure generate "$results" -o "$report"
        
        rm -rf "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY/results"
    fi
}
