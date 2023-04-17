# Isolates Python Environment.
bash_ci_require_pyenv() {
    body() {
        local pyenv_name=$1
        local python_version=${2:-$(get_default_python_version)}

        if [ -z "$pyenv_name" ]
        then
            fatal_error "Error: bash_ci_require_pyenv should be called with 1 argument: pyenv_name. Example: build_for_testing_v1"
        fi

        if [ "${__PYENV_IS_ALREADY_SET_UP:-false}" == "true" ]
        then
            return 0
        fi

        which pyenv || fatal_error "pyenv is not installed. try: brew install pyenv"
        which pyenv-virtualenv || fatal_error "pyenv-virtualenv is not installed. try: brew install pyenv-virtualenv"
        brew ls --versions zlib || fatal_error "zlib is not installed. try: brew install zlib"

        install_python_via_pyenv "$python_version"

        pyenv virtualenv "$python_version" "$pyenv_name" || true

        # After those commands pip3/python3/pytest will refer to those in virtualenv
        eval "$(pyenv init -)"
        __safely_eval_virtualenv_init
        pyenv local "$pyenv_name"

        __PYENV_IS_ALREADY_SET_UP=true
    }

    { set +x; } 2>/dev/null && ci_log_block "Isolating Python environment with pyenv and virtualenv" body ${@+"$@"}
}

__safely_eval_virtualenv_init() {
    # Fixes this error: `line 42: PROMPT_COMMAND: unbound variable`, it's in virtualenv's code
    
    local old_options; old_options=$(bash_save_options)
    
    set +u
    
    eval "$(pyenv virtualenv-init -)"
    
    bash_restore_options "$old_options"
}

# Installs requirements.txt
bash_ci_require_python_packages() {
    local requirements_txt_location=$1

    body() {
        local requirements_txt_location=$1

        __assert_pyenv_is_set_up
        __bash_ci_pip3_install -r "$requirements_txt_location"
    }

    { set +x; } 2>/dev/null && ci_log_block "Ensuring python requirements are met using file: $requirements_txt_location" body ${@+"$@"}
}

# Installs python package
bash_ci_require_python_package() {
    local package=$1 # Example: "jinja2==2.11.1"

    body() {
        local package=$1

        __assert_pyenv_is_set_up
        __bash_ci_pip3_install "$package"
    }

    { set +x; } 2>/dev/null && ci_log_block "Ensuring required package is present: $package" body ${@+"$@"}
}

# Runs python with custom PYTHONPATH (affects `import`s)
bash_ci_run_python3() {
    body() {
        PYTHONPATH=$PYTHON_ROOT python3 ${@+"$@"}
    }

    { set +x; } 2>/dev/null && ci_log_block "Running python with arguments: $@" body ${@+"$@"}
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
        fatal_error "Pyenv was not set up. The build is not safe. Use \`bash_ci_require_pyenv\`"
    fi
}
