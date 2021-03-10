import Git

public final class BeforeReleaseTagsSetterImpl: BeforeReleaseTagsSetter {
    private let gitTagAdder: GitTagAdder
    
    public init(gitTagAdder: GitTagAdder) {
        self.gitTagAdder = gitTagAdder
    }
    
    public func setUpTagsBeforeRelease(
        version: Version,
        commitHash: String,
        remote: String)
        throws
    {
        let versionString = version.toString()
        
        try gitTagAdder.addAndPushTag(
            tagName: versionString,
            commitHash: commitHash,
            remote: remote
        )
        try gitTagAdder.addAndPushTag(
            tagName: "UnfinishedRelease_\(versionString)",
            commitHash: commitHash,
            remote: remote
        )
    }
}
