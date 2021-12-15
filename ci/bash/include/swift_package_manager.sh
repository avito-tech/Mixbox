spm_reopen_project() {
    local xcode_app_name=`xcode-select -p|grep -oE "([^/]+.app)"|sed 's/\.app//'`
    local xcodeproj_relative=`ls -1|grep ".xcodeproj"`
    local xcodeproj_absolute=$SCRIPT_ROOT/$xcodeproj_relative
        
    # To avoid "The file “project.xcworkspace” has been modified by another application." nonsense after reopening Xcode
    rm -rfv "$xcodeproj_absolute"/project.xcworkspace || __ignore_error
    
    osascript -e '
        tell application "'$xcode_app_name'"
           tell workspace document "'$xcodeproj_relative'"
               close saving yes
           end tell
        end tell' || __ignore_error
    
    if ! spm_generate_xcodeproj
    then
        echo -e "\033[1;31m" # red color
        echo '/!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\'
        echo
        echo "Failed to generate project!"
        echo 
        echo "Press:"
        echo " - [Enter] to open Package.template.swift and PackageGenerator.swift"
        echo " - [Ctrl]+[C] to cancel"
        echo
        echo '/!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\'
        echo -e "\033[0m"
        
        read
        
        open "Package.template.swift" "PackageGenerator.swift"
        
        exit 1
    fi
    
    echo "Ignore the following \"missing value\" log:"
    osascript -e '
        tell application "'$xcode_app_name'"
           open "'$xcodeproj_absolute'"
        end tell'

    echo "Quote from Apple about this \"missing value\" log:"
    echo "> KNOWN ISSUE: The open command in Xcode sometimes fails to return the opened document."
    echo "> It is recommended to ignore the result of the open command and instead find the opened"
    echo "> document in the application's documents."
}

spm_generate_xcodeproj() {
    local swift_arguments=(package generate-xcodeproj --enable-code-coverage)
    local xcconfig_path=Package.xcconfig
    
    [ -e "$xcconfig_path" ] && swift_arguments=("${swift_arguments[@]}" --xcconfig-overrides "$xcconfig_path")
    
    spm_generate_package \
        && swift package generate-xcodeproj --enable-code-coverage
}

# Prevents the following error:
# `Compiling for macOS 10.13, but module 'AtomicModels' has a minimum deployment target of macOS 10.14: /some/path/AtomicModels.framework/Modules/AtomicModels.swiftmodule/x86_64-apple-macos.swiftmodule`
# TODO: Fix SPM in Emcee?
spm_patch_macosx_deployment_target() {  
    local xcodeproj_relative=`ls -1|grep ".xcodeproj"`
    local pbxproj_absolute=$SCRIPT_ROOT/$xcodeproj_relative/project.pbxproj
    local temporary_file=/tmp/`uuidgen`
    
    cat "$pbxproj_absolute" \
        | perl -pe 's/MACOSX_DEPLOYMENT_TARGET = "10.13"/MACOSX_DEPLOYMENT_TARGET = "10.14"/' \
        > "$temporary_file"
    
    rm "$pbxproj_absolute"
    mv "$temporary_file" "$pbxproj_absolute"
}

spm_clean_project() {
    swift package clean
    swift package reset
    rm -rf .build
    rm -rf *.xcodeproj
}

spm_build_project() {
    local product=$1

    args=( \
        swift build \
        -c release \
        --triple "$__MIXBOX_CI_MACOS_DEPLOYMENT_TARGET" \
    )
    
    if ! [ -z "$product" ]
    then
        args=("${args[@]}" --product "$product")
    fi
    
    "${args[@]}"
}

spm_test_project() {
    swift test \
        --triple "$__MIXBOX_CI_MACOS_DEPLOYMENT_TARGET"
}

spm_make_file_main() {
    local action=$1
    
    __MIXBOX_CI_MACOS_DEPLOYMENT_TARGET=x86_64-apple-macosx11.0
    cd "$SCRIPT_ROOT"

    case "$action" in
        generate) spm_generate_xcodeproj;;
        reopen) spm_reopen_project;;
        clean) spm_clean_project;;
        build) spm_build_project "${2:-}";;
        test) spm_test_project;;
        *) __fatal_error "Unknown action: $action. Known actions: generate, reopen, reopen-fast, clean, build <target_name>, test";;
    esac
}
