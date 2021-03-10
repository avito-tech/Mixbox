public protocol SetUpAction {
    func setUp() -> TearDownAction
}
