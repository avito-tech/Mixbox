public protocol CocoapodsRepoPush {
    func push(
        repoName: String,
        pathToPodspec: String,
        verbose: Bool,
        localOnly: Bool,
        allowWarnings: Bool,
        skipImportValidation: Bool,
        skipTests: Bool)
        throws
}
