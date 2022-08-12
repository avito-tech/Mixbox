#!/bin/bash

set -xueo pipefail

# ====== bash_ci ======
# This section should be same across all bash files in the project
source "$(builtin cd "$(dirname "$0")" && git rev-parse --show-toplevel)/ci/bash/bash_ci.sh"
# =====================

# Overrides

spm_generate_package() {
    if [ -z "$EMCEE_REPOSITORY_URL" ]; then
        echo "Error: EMCEE_REPOSITORY_URL environment variable is not set"
        echo "Note: This CI uses proprietary code (Emcee with versions later than 2022) and will not work without proprietary software of specified version"
    fi
    
    bash_ci_require_pyenv make_v1
    bash_ci_require_python_packages ./MakePackage/requirements.txt
    bash_ci_run_python3 ./MakePackage/make_package.py
    
    swift \
        package \
        config \
        set-mirror \
        --original-url "https://github.com/avito-tech/Emcee" \
        --mirror-url "$EMCEE_REPOSITORY_URL"
}

# Main

spm_make_file_main "$@"
