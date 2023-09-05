#!/bin/bash

set -xueo pipefail

# ====== bash_ci ======
# This section should be same across all bash files in the project
source "$(builtin cd "$(dirname "$0")" && git rev-parse --show-toplevel)/ci/bash/bash_ci.sh"
# =====================

# Overrides

spm_generate_package() {
    body() {
        bash_ci_require_pyenv make_v1
        bash_ci_require_python_packages ./MakePackage/requirements.txt
        bash_ci_run_python3 ./MakePackage/make_package.py || fatal_error "Failed to make package"

        if [ -z "${MIXBOX_CI_MIRRORS_JSON_FILE_PATH:-}" ]; then
            echo "Error: MIXBOX_CI_MIRRORS_JSON_FILE_PATH environment variable is not set"
            echo "Note: This CI uses proprietary code (Emcee with versions later than April 2022) and will not work without proprietary software of specified version"
        else
            # Note: mirrors will stay here after being copied once.
            # It's useful for local development.
            # To remove mirrors you have to remove them manually.
            mkdir -p .swiftpm/configuration
            cp -f "$MIXBOX_CI_MIRRORS_JSON_FILE_PATH" .swiftpm/configuration/mirrors.json
        fi
    }

    { set +x; } 2>/dev/null && ci_log_block "Generating package" body ${@+"$@"}
}

# Main

spm_make_file_main "$@"
