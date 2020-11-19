public final class CompoundTearDownAction: TearDownAction {
    private let tearDownActions: [TearDownAction]
    
    public init(
        tearDownActions: [TearDownAction])
    {
        self.tearDownActions = tearDownActions
    }
    
    public func tearDown() {
        tearDownActions.forEach {
            $0.tearDown()
        }
    }
}
