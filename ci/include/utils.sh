fatalError() {
    echo $@ >&2
    
    # Can be unexpected in future. When "After Testing" will have no sense for current build configuration, e.g. Linter.
    echo "Cleaning up everything..."
    cleanUpAfterTesting
    
    kill $$
}
