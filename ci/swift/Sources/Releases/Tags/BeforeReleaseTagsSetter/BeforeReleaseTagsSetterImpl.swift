import Git

public final class BeforeReleaseTagsSetterImpl:
    BeforeReleaseTagsSetter,
    AfterReleaseTagsSetterForExistingReleaseProvider
{
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
        
        let unfinishedReleaseMarkerTagName = self.unfinishedReleaseMarkerTagName(
            versionString: versionString
        )
        
        try gitTagAdder.addAndPushTag(
            tagName: unfinishedReleaseMarkerTagName,
            commitHash: commitHash,
            remote: remote
        )
        
        return afterReleaseTagsSetter(
            unfinishedReleaseMarkerTagName: unfinishedReleaseMarkerTagName,
            remoteName: remote
        )
    }
    
    public func afterReleaseTagsSetterForExistingRelease(
        version: Version,
        remote: String)
        -> AfterReleaseTagsSetter
    {
        return afterReleaseTagsSetter(
            unfinishedReleaseMarkerTagName: unfinishedReleaseMarkerTagName(
                versionString: version.toString()
            ),
            remoteName: remote
        )
    }
    
    private func afterReleaseTagsSetter(
        unfinishedReleaseMarkerTagName: String,
        remoteName: String)
        -> AfterReleaseTagsSetter
    {
        return AfterReleaseTagsSetterImpl { [gitTagDeleter] in
            try gitTagDeleter.deleteLocalAndRemoteTag(
                tagName: unfinishedReleaseMarkerTagName,
                remoteName: remoteName
            )
        }
    }
    
    private func unfinishedReleaseMarkerTagName(versionString: String) -> String {
        return "UnfinishedRelease_\(versionString)"
    }
}
