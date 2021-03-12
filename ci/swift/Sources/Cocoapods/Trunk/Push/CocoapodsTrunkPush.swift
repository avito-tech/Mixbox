public protocol CocoapodsTrunkPush {
    func push(
        pathToPodspec: String,
        allowWarnings: Bool,
        skipImportValidation: Bool,
        skipTests: Bool)
        throws
}
