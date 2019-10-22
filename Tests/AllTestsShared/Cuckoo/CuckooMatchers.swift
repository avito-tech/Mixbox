import Cuckoo

func isInstance<T, U>(of type: U.Type) -> ParameterMatcher<T> {
    return ParameterMatcher {
        $0 is U
    }
}
