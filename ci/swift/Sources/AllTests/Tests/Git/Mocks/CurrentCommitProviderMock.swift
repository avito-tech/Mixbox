import Git

public final class CurrentCommitProviderMock: CurrentCommitProvider {
    private let currentCommitStub: String
    
    public init(currentCommit: String) {
        self.currentCommitStub = currentCommit
    }
    
    public func currentCommit(
        repoRoot: String)
        throws
        -> String
    {
        return currentCommitStub
    }
}
