import Destinations

public protocol IosProjectBuilder {
    func prepareForIosTesting(rebootSimulator: Bool, testDestination: MixboxTestDestination) throws
    
    func build(
        projectDirectoryFromRepoRoot: String,
        action: XcodebuildAction,
        scheme: String,
        workspaceName: String,
        testDestination: MixboxTestDestination,
        xcodebuildPipeFilter: String)
        throws
        -> XcodebuildResult
    
    func cleanUpAfterIosTesting() throws
}

extension IosProjectBuilder {
    public func withPreparationAndCleanup(rebootSimulator: Bool, testDestination: MixboxTestDestination, body: (IosProjectBuilder, MixboxTestDestination) throws -> ()) throws {
        try prepareForIosTesting(rebootSimulator: rebootSimulator, testDestination: testDestination)
        
        try body(self, testDestination)
        
        try cleanUpAfterIosTesting()
    }
    
    public func test(
        projectDirectoryFromRepoRoot: String,
        scheme: String,
        workspaceName: String,
        testDestination: MixboxTestDestination,
        xcodebuildPipeFilter: String)
        throws
    {
        try withPreparationAndCleanup(
            rebootSimulator: true,
            testDestination: testDestination,
            body: { iosProjectBuilder, testDestination in
                _ = try iosProjectBuilder.build(
                    projectDirectoryFromRepoRoot: projectDirectoryFromRepoRoot,
                    action: .test,
                    scheme: scheme,
                    workspaceName: workspaceName,
                    testDestination: testDestination,
                    xcodebuildPipeFilter: xcodebuildPipeFilter
                )
            }
        )
    }
}
