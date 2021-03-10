public protocol BeforeReleaseTagsSetter {
    func setUpTagsBeforeRelease(
        version: Version,
        commitHash: String,
        remote: String)
        throws
}
