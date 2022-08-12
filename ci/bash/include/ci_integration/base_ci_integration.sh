# Example:
#
# ```
# set_up_dependencies() {
#     body() {
#         do_some_work
#         do_some_work
#     }
#
#     { set +x; } 2>/dev/null && ci_log_block "Set up dependencies" body ${@+"$@"}
# }
#
# ```
#
# This is the best way to wrap code in block.
# `${@+"$@"}` passes all arguments as is. `body` is a local function.
#
# You can also write code like this, but it's easier to make mistakes this way:
#
# ```
# set_up_dependencies() {
#     { set +x; } 2>/dev/null && ci_log_block "Set up dependencies" do_some_work any number of args
# }
# ```
#
function ci_log_block() {
	{ set +x; } 2>/dev/null

    local message=$1
    shift 1
    local result=0

    [ $# -gt 0 ] || fatal_error "ci_log_block requires at least one argument (name of the function/executable)"

    __ci_open_block_message "$message"

    # In case of failure, save the result instead of exiting the function early
    "$@" || result=$?

    __ci_close_block_message "$message"

    # Code is written this way to prevent outputting in logs (while setting `-x` option)
	{ set -x; } 2>/dev/null
    { return $result; } 2>/dev/null
}

# Prefer using `ci_log_block`, it is more robust and closes itself (even if code within block fails).
function ci_open_block() {
	{ set +x; } 2>/dev/null
    local message=$1
	__ci_open_block_message "$message"
	{ set -x; } 2>/dev/null
}

function ci_close_block() {
	{ set +x; } 2>/dev/null
    local message=$1
    __ci_close_block_message "$message"
	{ set -x; } 2>/dev/null
}

function ci_set_error_and_exit() {
    local message=$1
    ci_set_error "$message"
    exit 1
}