function ci_set_error() {
	{ set +x; } 2>/dev/null
    local message=$1
	echo "Error: $message"
	{ set -x; } 2>/dev/null
}

function ci_warning() {
	{ set +x; } 2>/dev/null
    local message=$1
	echo "Warning: $message"
	{ set -x; } 2>/dev/null
}

# INTERNAL

function __ci_open_block_message() {
    local message=$1
    echo "$message..."
    { sync; } 2>/dev/null
}

function __ci_close_block_message() {
    local message=$1
    echo "$message: Done."
    { sync; } 2>/dev/null
}
