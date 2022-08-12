import Git

public final class GitRevListProviderMock: GitRevListProvider {
    private let revListStub: [String]
    
    public init(revList: [String]) {
        self.revListStub = revList
    }
    
    public func revList(
        branch: String)
        throws
        -> [String]
    {
        return revListStub
    }
}
