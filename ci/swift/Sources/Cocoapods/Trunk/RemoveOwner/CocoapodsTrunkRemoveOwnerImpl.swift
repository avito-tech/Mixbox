import CiFoundation

public final class CocoapodsTrunkRemoveOwnerImpl: CocoapodsTrunkRemoveOwner {
    private let cocoapodsTrunkCommandExecutor: CocoapodsTrunkCommandExecutor
    
    public init(
        cocoapodsTrunkCommandExecutor: CocoapodsTrunkCommandExecutor)
    {
        self.cocoapodsTrunkCommandExecutor = cocoapodsTrunkCommandExecutor
    }
    
    public func removeOwner(
        podName: String,
        ownerEmail: String)
        throws
    {
        _ = try cocoapodsTrunkCommandExecutor.execute(
            arguments: [
                "remove-owner",
                podName,
                ownerEmail
            ]
        )
    }
}
