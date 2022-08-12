import Git

public final class GitTagsProviderMock: GitTagsProvider {
    private let gitTagsStub: [GitTag]
    
    public init(gitTags: [GitTag]) {
        self.gitTagsStub = gitTags
    }
    
    public func gitTags() throws -> [GitTag] {
        return gitTagsStub
    }
}
