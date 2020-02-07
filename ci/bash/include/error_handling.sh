# Convenient method to report errors
# Example: cat foo | grep bar || __fatal_error "Can not find bar in foo"
__fatal_error() {
    echo $@
    exit 1
}

# Convenient method to ignore errors
# Example: rm foo || __ignore_error"
__ignore_error() {
    true
}
