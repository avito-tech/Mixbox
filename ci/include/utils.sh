fatalError() {
    echo $@ >&2
    kill $$
}
