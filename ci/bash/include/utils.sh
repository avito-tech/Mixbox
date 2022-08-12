# __join_array_with_separator ", " 1 2 3 ---> "1, 2, 3"
join_array_with_separator() {
    local separator="$1"
    shift

    echo -n "$1"
    shift
    for component in "${@}"; do
        echo -n "$separator"
        echo -n "$component"
    done

    echo
}
