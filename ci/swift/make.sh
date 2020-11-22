#!/bin/bash

set -xueo pipefail

# ====== bash_ci ======
# This section should be same across all bash files in the project
source "$(builtin cd "$(dirname "$0")" && git rev-parse --show-toplevel)/ci/bash/bash_ci.sh"
# =====================

# Overrides

spm_generate_package() {
    bash_ci_require_pyenv make_v1
    bash_ci_require_python_packages ./MakePackage/requirements.txt
    bash_ci_run_python3 ./MakePackage/make_package.py || exit 
}

# Main

spm_make_file_main "$@"
