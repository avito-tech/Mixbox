import CiFoundation

public final class CocoapodsTrunkAddOwnerImpl: CocoapodsTrunkAddOwner {
    private let cocoapodsTrunkCommandExecutor: CocoapodsTrunkCommandExecutor
    
    public init(
        cocoapodsTrunkCommandExecutor: CocoapodsTrunkCommandExecutor)
    {
        self.cocoapodsTrunkCommandExecutor = cocoapodsTrunkCommandExecutor
    }
    
    public func addOwner(
        podName: String,
        ownerEmail: String)
        throws
    {
        _ = try cocoapodsTrunkCommandExecutor.execute(
            arguments: [
                "add-owner",
                podName,
                ownerEmail
            ]
        )
    }
}
