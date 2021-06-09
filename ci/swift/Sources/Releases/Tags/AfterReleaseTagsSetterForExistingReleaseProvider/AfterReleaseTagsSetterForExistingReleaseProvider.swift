public protocol AfterReleaseTagsSetterForExistingReleaseProvider {
    func afterReleaseTagsSetterForExistingRelease(
        version: Version,
        remote: String)
        -> AfterReleaseTagsSetter
}
