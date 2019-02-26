installEmceeWithDependencies() {
    installLibssh
    installEmcee
}

installLibssh() {    
    brew ls --versions libssh2 > /dev/null || brew install libssh2
}

installEmcee() {
    echo "Installing Emcee..."
    
    avitoRunnerBinaryPath=`ls -1 "$MIXBOX_CI_TEMPORARY_DIRECTORY"/Emcee/.build/x86_64-*/debug/AvitoRunner|head -1` || true
    
    if [ -e "$avitoRunnerBinaryPath" ]
    then
        : # skip
    else
        cd "$MIXBOX_CI_TEMPORARY_DIRECTORY"
            
        git clone https://github.com/avito-tech/Emcee
        cd Emcee
        make generate
        make build
    fi
        
    avitoRunnerBinaryPath=`ls -1 "$MIXBOX_CI_TEMPORARY_DIRECTORY"/Emcee/.build/x86_64-*/debug/AvitoRunner|head -1`
    
    [ -e "$avitoRunnerBinaryPath" ] || fatalError "Failed to install Emcee"
}

testUsingEmceeWith_appName_testsTarget() {
    local appName=$1
    local testsTarget=$2
    local runnerAppName=$testsTarget-Runner.app
    local derivedDataPath=`derivedDataPath`

    mkdir -p "$MIXBOX_CI_REPORTS_PATH"

    echo "Running tests"

    cd "$MIXBOX_CI_SCRIPT_DIRECTORY"
    
    local fbxctestUrl="http://artifactory.msk.avito.ru/artifactory/ios-ci/fb/fbxctest/fbxctest_20181120T145305.zip"
    local fbsimctlUrl="http://artifactory.msk.avito.ru/artifactory/ios-ci/fb/fbsimctl/fbsimctl_20181120T145356.zip"
    
    local sourceEnvironment="$MIXBOX_CI_SCRIPT_DIRECTORY/emcee/environment.json"
    local environment="$derivedDataPath/environment.json"
    
    if [ -z "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY" ]
    then
        cp "$sourceEnvironment" "$environment"
    else
        rm -rf "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY"
        mkdir -p "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY"
        
        cat "$sourceEnvironment" \
            | jq ". + {\"MIXBOX_CI_ALLURE_REPORTS_DIRECTORY\": \"$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY\"}" \
            > "$environment"
    fi
    
    "$avitoRunnerBinaryPath" runTests \
    --fbsimctl "$fbsimctlUrl" \
    --fbxctest "$fbxctestUrl" \
    --junit "$MIXBOX_CI_REPORTS_PATH/junit.xml" \
    --trace "$MIXBOX_CI_REPORTS_PATH/trace.combined.json" \
    --environment "$environment" \
    --test-destinations "$(destinationFile)" \
    --number-of-retries 2 \
    --number-of-simulators 3 \
    --schedule-strategy "progressive" \
    --single-test-timeout 1200 \
    --fbxctest-bundle-ready-timeout 600 \
    --fbxctest-crash-check-timeout 600 \
    --fbxctest-fast-timeout 600 \
    --fbxctest-regular-timeout 600 \
    --fbxctest-silence-timeout 600 \
    --fbxctest-slow-timeout 1200 \
    --temp-folder "$derivedDataPath" \
    --runner "$derivedDataPath/Build/Products/Debug-iphonesimulator/$testsTarget-Runner.app" \
    --app "$derivedDataPath/Build/Products/Debug-iphonesimulator/$appName" \
    --xctest-bundle "$derivedDataPath/Build/Products/Debug-iphonesimulator/$testsTarget-Runner.app/PlugIns/$testsTarget.xctest"
}

generateReports() {
    if ! [ -z "$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY" ]
    then
        which allure || brew install allure

        local results="$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY/results"
        local report="$MIXBOX_CI_ALLURE_REPORTS_DIRECTORY/report"
        
        allure generate "$results" -o "$report"
    fi
}