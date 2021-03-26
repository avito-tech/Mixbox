import MixboxUiTestsFoundation

public final class XcuiApplicationQuiescenceWaiter: ApplicationQuiescenceWaiter {
    private let applicationProvider: ApplicationProvider
    
    public init(
        applicationProvider: ApplicationProvider)
    {
        self.applicationProvider = applicationProvider
    }
    
    public func waitForQuiescence() throws {
        fatalError()
//        applicationProvider.application._waitForQuiescence()
    }
}
