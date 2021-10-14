extension BaseTestCase {
    func valuesByIosVersion<T>(type: T.Type = T.self) -> ValuesByIosVersionInInitialState<T> {
        return ValuesByIosVersionInInitialState(
            iosVersionProvider: iosVersionProvider
        )
    }
}
