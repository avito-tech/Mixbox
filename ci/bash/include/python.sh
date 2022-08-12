# Isolates Python Environment.
bash_ci_require_pyenv() {
    local pyenv_name=$1
    local python_version=${2:-$(get_default_python_version)}
    
    if [ -z "$pyenv_name" ]
    then
        __fatalError "Error: bash_ci_require_pyenv should be called with 1 argument: pyenv_name. Example: build_for_testing_v1"
    fi
    
    if [ "${__PYENV_IS_ALREADY_SET_UP:-false}" == "true" ]
    then
        return 0
    fi
    
    which pyenv || brew install pyenv
    which pyenv-virtualenv || brew install pyenv-virtualenv
    brew ls --versions zlib || brew install zlib

    install_python_via_pyenv "$python_version"

    pyenv virtualenv "$python_version" "$pyenv_name" || true

    # After those commands pip3/python3/pytest will refer to those in virtualenv
    eval "$(pyenv init -)"
    __safely_eval_virtualenv_init
    pyenv local "$pyenv_name"
    
    __PYENV_IS_ALREADY_SET_UP=true
}

__safely_eval_virtualenv_init() {
    # Fixes this error: `line 42: PROMPT_COMMAND: unbound variable`, it's in virtualenv's code
    
    local old_options=$(bash_save_options)
    
    set +u
    
    eval "$(pyenv virtualenv-init -)"
    
    bash_restore_options "$old_options"
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

# `--no-cache` was added to work around https://github.com/pypa/pip/issues/6240
# Note: `-vvv` option is useful for debugging.
__bash_ci_pip3_install() {
    pip3 install \
        --no-cache \
        -i "https://pypi.org/simple" \
        "$@"
}

__assert_pyenv_is_set_up() {
    if [ "$__PYENV_IS_ALREADY_SET_UP" != "true" ]
    then
        __fatal_error "Pyenv was not set up. The build is not safe. Use `bash_ci_require_pyenv`"
    fi
}
