spm_reopen_project() {
    local xcode_app_name; xcode_app_name=$(xcode-select -p | grep -oE "([^/]+.app)" | sed 's/\.app//')
    local package_directory_path_absolute=$SCRIPT_ROOT
    local package_swift_path_absolute=$package_directory_path_absolute/Package.swift
    
    # Note: to get API of Xcode, open "Script Editor", select "File" -> "Open Dictionary...", select Xcode
    osascript -e '
        tell application "'"$xcode_app_name"'"
            if count of workspace documents > 0 then
                repeat with index_of_document from 0 to count of workspace documents
                    set document_path to path of workspace document index_of_document

                    considering case
                        if document_path = "'"$package_directory_path_absolute"'" then
                            tell workspace document index_of_document
                                close saving yes
                            end tell
                            exit repeat
                        end if
                    end considering
                end repeat
            end if
        end tell'
    
    if ! spm_generate_package
    then
        files_to_open=("Package.template.swift")
        
        [ -e "Package.swift" ] && files_to_open=("${files_to_open[@]}" "Package.swift")
        [ -e "PackageGenerator.swift" ] && files_to_open=("${files_to_open[@]}" "Package.swift")
        
        echo -e "\033[1;31m" # red color
        echo '/!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\'
        echo
        echo "Failed to generate project!"
        echo 
        echo "Press:"
        echo " - [Enter] to open files: $(__join_array_with_separator ", " "${files_to_open[@]}")"
        echo " - [Ctrl]+[C] to cancel"
        echo
        echo '/!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\'
        echo -e "\033[0m"
        
        read
        
        open "${files_to_open[@]}"
        
        exit 1
    fi

    __assert_package_swift_exists
    
    osascript -e '
        tell application "'"$xcode_app_name"'"
           open "'"$package_swift_path_absolute"'"
        end tell'
}

spm_clean_project() {
    body() {
        swift package clean
        swift package reset
        rm -rf .build
        rm -rf *.xcodeproj
    }

    { set +x; } 2>/dev/null && ci_log_block "Cleaning project" body ${@+"$@"}
}

spm_build_project() {
    local product=$1

    __assert_package_swift_exists

    args=(swift build --configuration release)

    local message
    if ! [ -z "$product" ]
    then
        args=("${args[@]}" --product "$product")
        message="Building product: $product"
    else
        message="Building project"
    fi

    { set +x; } 2>/dev/null && ci_log_block "$message" "${args[@]}"
}

spm_test_project() {
    body() {
        __assert_package_swift_exists

        swift test --triple
    }

    { set +x; } 2>/dev/null && ci_log_block "Testing project" body ${@+"$@"}
}

spm_launch_product() {
    local product=$1

    body() {
        local product=$1

        local bin_path; bin_path=$(swift build --configuration release --product "$product" --show-bin-path)

        executable="$bin_path/$MIXBOX_CI_BUILD_EXECUTABLE"

        if [ -x "$executable" ]
        then
            echo "Executing $executable"
            "$executable"
            return $?
        fi

        echo "Failed to find executable $MIXBOX_CI_BUILD_EXECUTABLE inside .build directory"
        echo "Note that you may update this script. Here is output of find:"
        find "$REPO_ROOT" -name "$MIXBOX_CI_BUILD_EXECUTABLE"
    }

    { set +x; } 2>/dev/null && ci_log_block "Executing $product" body ${@+"$@"}
}

spm_make_file_main() {
    local action=$1
    
    cd "$SCRIPT_ROOT" || fatal_error "failed to \"cd $SCRIPT_ROOT\""

    case "$action" in
        generate) spm_generate_package;;
        reopen) spm_reopen_project;;
        clean) spm_clean_project;;
        build) spm_generate_package; spm_build_project "${2:-}";;
        test) spm_generate_package; spm_test_project;;
        launch) shift; spm_launch_product "$@";;
        *) fatal_error "Unknown action: $action. Known actions: generate, reopen, reopen-fast, clean, build <target_name>, test";;
    esac
}

__assert_package_swift_exists() {
    [ -e "Package.swift" ] || fatal_error "Package.swift was not found"
}
