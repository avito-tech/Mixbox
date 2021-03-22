public protocol CocoapodsTrunkPush {
    func push(
        pathToPodspec: String,
        allowWarnings: Bool,
        skipImportValidation: Bool,
        skipTests: Bool,
        // `synchronous` resolves this issue: https://github.com/CocoaPods/CocoaPods/issues/9497
        // This is a PR with it: https://github.com/CocoaPods/cocoapods-trunk/pull/147
        // The issue really happened, here's the error:
        // ```
        // Validating podspec
        //  -> MixboxGenerators (0.2.80)
        //     - ERROR | [iOS] unknown: Encountered an unknown error (Unable to find a specification for `MixboxDi` depended upon by `MixboxGenerators`
        // ```
        synchronous: Bool)
        throws
}
