# Convenient method to report errors
# Example: cat foo | grep bar || fatal_error "Can not find bar in foo"
fatal_error() {
    echo ${@+"$@"}
    exit 1
}

# Convenient method to ignore errors
# Example: rm foo || ignore_error"
ignore_error() {
    true
}
