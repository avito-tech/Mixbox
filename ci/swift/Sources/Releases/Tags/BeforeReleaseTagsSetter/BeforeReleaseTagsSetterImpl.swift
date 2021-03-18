import Git

public final class BeforeReleaseTagsSetterImpl: BeforeReleaseTagsSetter {
    private let gitTagAdder: GitTagAdder
    private let gitTagDeleter: GitTagDeleter
    
    private class AfterReleaseTagsSetterImpl: AfterReleaseTagsSetter {
        private let setUpTagsAfterReleaseImpl: () throws -> ()
        
        init(setUpTagsAfterRelease: @escaping () throws -> ()) {
            self.setUpTagsAfterReleaseImpl = setUpTagsAfterRelease
        }
        
        func setUpTagsAfterRelease() throws {
            try setUpTagsAfterReleaseImpl()
        }
    }
    
    public init(
        gitTagAdder: GitTagAdder,
        gitTagDeleter: GitTagDeleter)
    {
        self.gitTagAdder = gitTagAdder
        self.gitTagDeleter = gitTagDeleter
    }
    
    public func setUpTagsBeforeRelease(
        version: Version,
        commitHash: String,
        remote: String)
        throws
        -> AfterReleaseTagsSetter
    {
        let versionString = version.toString()
        
        try gitTagAdder.addAndPushTag(
            tagName: versionString,
            commitHash: commitHash,
            remote: remote
        )
        
        let unfinishedReleaseMarkerTagName = "UnfinishedRelease_\(versionString)"
        
        try gitTagAdder.addAndPushTag(
            tagName: unfinishedReleaseMarkerTagName,
            commitHash: commitHash,
            remote: remote
        )

        return AfterReleaseTagsSetterImpl { [gitTagDeleter] in
            try gitTagDeleter.deleteLocalAndRemoteTag(
                tagName: unfinishedReleaseMarkerTagName,
                remoteName: remote
            )
        }
    }
}
