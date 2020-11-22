#!/bin/bash

set -ueo pipefail

# ====== bash_ci ======
# This section should be same across all bash files in the project
source "$(builtin cd "$(dirname "$0")" && git rev-parse --show-toplevel)/ci/bash/bash_ci.sh"
# =====================

# Overrides

spm_generate_package() {
    local return_value=0
    
    cd "$REPO_ROOT"
    
    swift "PackageGenerator.swift" || return_value=1
    
    cd -
    
    return $return_value
}

# Main

spm_make_file_main "$@"
