# Do not add functions here, use files from `include`. So everything will be perfectly organized.
# Do not add enviromnent in files from `include`. So the order of includes will not affect behavior.

# SETTING UP ENVIRONMENT

# Link to the script that includes this file
SCRIPT_ROOT=$(builtin cd "$(dirname "$0")" && pwd)

# Link to root of the repository. Note: will only work if this file that includes this file is inside repo ($0).
REPO_ROOT=$(builtin cd "$SCRIPT_ROOT" && git rev-parse --show-toplevel)

PYTHON_ROOT="$REPO_ROOT"

# EXPOSE BASH FUNCTIONS

source "$REPO_ROOT"/ci/bash/include/install_python.sh
source "$REPO_ROOT"/ci/bash/include/python.sh
source "$REPO_ROOT"/ci/bash/include/error_handling.sh
source "$REPO_ROOT"/ci/bash/include/swift_package_manager.sh
source "$REPO_ROOT"/ci/bash/include/bash_utils.sh
