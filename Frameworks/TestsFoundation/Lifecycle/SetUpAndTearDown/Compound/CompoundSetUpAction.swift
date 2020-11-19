public final class CompoundSetUpAction: SetUpAction {
    private let setUpActions: [SetUpAction]
    
    public init(
        setUpActions: [SetUpAction])
    {
        self.setUpActions = setUpActions
    }
    
    public func setUp() -> TearDownAction {
        return CompoundTearDownAction(
            tearDownActions: Array(setUpActions.map { $0.setUp() }.reversed())
        )
    }
}
