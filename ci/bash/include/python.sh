# Isolates Python Environment.
bash_ci_require_pyenv() {
    local pyenv_name=$1
    local python_version=${2:-"3.7.1"}
    
    if [ -z "$pyenv_name" ]
    then
        __fatalError "Error: bash_ci_require_pyenv should be called with 1 argument: pyenv_name. Example: build_for_testing_v1"
    fi
    
    if [ "${__PYENV_IS_ALREADY_SET_UP:-false}" == "true" ]
    then
        return 0
    fi
    
    __install_command_line_tools_if_needed
    __install_mac_os_sdk_headers_if_needed
    
    which pyenv || brew install pyenv
    which pyenv-virtualenv || brew install pyenv-virtualenv
    brew ls --versions zlib || brew install zlib

    LDFLAGS="-L/usr/local/opt/zlib/lib" \
    CPPFLAGS="-I/usr/local/opt/zlib/include" \
    pyenv install -s "$python_version"

    pyenv virtualenv "$python_version" "$pyenv_name" || true

    # After those commands pip3/python3/pytest will refer to those in virtualenv
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv local "$pyenv_name"
    
    __PYENV_IS_ALREADY_SET_UP=true
}

# Installs requirements.txt
bash_ci_require_python_packages() {
    __assert_pyenv_is_set_up
    
    local requirements_txt_location=$1
    
    __bash_ci_pip3_install -r "$requirements_txt_location"
}

# Installs python package
bash_ci_require_python_package() {
    __assert_pyenv_is_set_up
    
    local package=$1 # Example: "jinja2==2.11.1"
    
    __bash_ci_pip3_install "$package"
}

# Runs python with custom PYTHONPATH (affects `import`s)
bash_ci_run_python3() {
    PYTHONPATH=$PYTHON_ROOT python3 "$@"
}

# PRIVATE

__bash_ci_pip3_install() {
    pip3 install \
        -i "https://pypi.org/simple" \
        "$@"
}

__install_command_line_tools_if_needed() {
    pkgutil --pkg-info=com.apple.pkg.CLTools_Executables || __install_command_line_tools
}

__install_command_line_tools() {
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

    local saved_IFS=$IFS
    IFS=$'\n'
    for package_name in $(softwareupdate -l|grep "\*.*Command Line"|awk -F"*" '{print $2}'|sed -e 's/^ *//')
    do
        softwareupdate -i "$package_name"
    done
    IFS=$saved_IFS
}

__install_mac_os_sdk_headers_if_needed() {
    # Example: "10.14"
    local short_mac_os_version=`system_profiler SPSoftwareDataType | grep "System Version" | awk '{print $4}' | sed "s:.[[:digit:]]*.$::g"`
    pkgutil --pkg-info="com.apple.pkg.macOS_SDK_headers_for_macOS_$short_mac_os_version" || __install_mac_os_sdk_headers_using_installer
}

# TODO: Check. It seems that it is outdated and can be removed:
__install_mac_os_sdk_headers_using_installer() {
    local short_mac_os_version=$1
    local expected_package_path="/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_$short_mac_os_version.pkg"
    if [[ -f "$expected_package_path" ]]; then
        sudo installer -pkg "$expectedPackagePath" -target /
    else
        # The package appeared in Mojave, in case it is not found, print this:
        echo "WARNING: no SDK headers package was found. If pyenv fails to install, then probably headers must be installed first."
    fi
}

__assert_pyenv_is_set_up() {
    if [ "$__PYENV_IS_ALREADY_SET_UP" != "true" ]
    then
        __fatal_error "Pyenv was not set up. The build is not safe. Use `bash_ci_require_pyenv`"
    fi
}
