function ci_set_error() {
	{ set +x; } 2>/dev/null
    local message=$1
    echo "##teamcity[buildStatus status='ERROR' text='$(__ci_encode "$message")']"
	{ set -x; } 2>/dev/null
}

function ci_warning() {
	{ set +x; } 2>/dev/null
    local message=$1
    echo "##teamcity[buildStatus status='WARNING' text='$(__ci_encode "$message")']"
	{ set -x; } 2>/dev/null
}

# INTERNAL

function __ci_open_block_message() {
    local message=$1
    echo "##teamcity[blockOpened name='$(__ci_encode "$message")']"
    { sync; } 2>/dev/null # force flush, to make teamcity not write messages outside of blocks
}

function __ci_close_block_message() {
    local message=$1
	echo "##teamcity[blockClosed name='$(__ci_encode "$message")']"
    { sync; } 2>/dev/null # force flush, to make teamcity not write messages outside of blocks
}

function __ci_encode {
    # Only unicode characters are not supported

    escape_regular_characters() {
        sed "s/\([|']\)/\|\1/g; s/\[/\|\[/g; s/\]/\|\]/g;"
    }

    # This does not work. It works in console, but there are empty names for blocks in Teamcity.
    #
    # escape_newlines() {
    #     sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/|n/g'
    # }

    echo -n "$1" | escape_regular_characters
}