import Git

public final class HeadCommitHashProviderMock: HeadCommitHashProvider {
    private let headCommitHashStub: String
    
    public init(headCommitHash: String) {
        self.headCommitHashStub = headCommitHash
    }
    
    public func headCommitHash()
        throws
        -> String
    {
        return headCommitHashStub
    }
}
