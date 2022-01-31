import Destinations

public protocol IosProjectBuilder {
    func prepare(rebootSimulator: Bool, destination: MixboxTestDestination) throws
    
    func build(
        projectDirectoryFromRepoRoot: String,
        action: XcodebuildAction,
        scheme: String,
        workspaceName: String,
        destination: MixboxTestDestination)
        throws
        -> XcodebuildResult
    
    func cleanUp(destination: MixboxTestDestination) throws
}

extension IosProjectBuilder {
    public func withPreparationAndCleanup<T>(
        rebootSimulator: Bool = true,
        destination: MixboxTestDestination,
        body: (IosProjectBuilder, MixboxTestDestination) throws -> T
    ) throws -> T {
        try prepare(rebootSimulator: rebootSimulator, destination: destination)
        
        let result = try body(self, destination)
        
        try cleanUp(destination: destination)
        
        return result
    }
    
    public func buildPreparationAndCleanup(
        rebootSimulator: Bool = true,
        projectDirectoryFromRepoRoot: String,
        action: XcodebuildAction,
        scheme: String,
        workspaceName: String,
        destination: MixboxTestDestination)
        throws
        -> XcodebuildResult
    {
        return try withPreparationAndCleanup(
            rebootSimulator: rebootSimulator,
            destination: destination,
            body: { builder, destination in
                try builder.build(
                    projectDirectoryFromRepoRoot: projectDirectoryFromRepoRoot,
                    action: action,
                    scheme: scheme,
                    workspaceName: workspaceName,
                    destination: destination
                )
            }
        )
    }
}
