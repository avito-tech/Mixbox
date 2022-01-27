import Tasks
import TestRunning

public final class RunUnitTestsTask: LocalTask {
    private let testsTaskRunner: TestsTaskRunner
    
    public init(
        testsTaskRunner: TestsTaskRunner)
    {
        self.testsTaskRunner = testsTaskRunner
    }
    
    public func execute() throws {
        try testsTaskRunner.runTests(
            build: { iosProjectBuilder, destinationForBuilding in
                try iosProjectBuilder.buildPreparationAndCleanup(
                    projectDirectoryFromRepoRoot: "Tests",
                    action: .buildForTesting,
                    scheme: "UnitTests",
                    workspaceName: "Tests",
                    destination: destinationForBuilding
                )
            },
            artifacts: { iosBuildArtifactsProvider in
                try iosBuildArtifactsProvider.iosLogicTests(
                    testsTarget: "UnitTests"
                )
            },
            additionalEnvironment: [:]
        )
    }
}
