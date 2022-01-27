import Tasks
import TestRunning

public final class RunBlackBoxTestsTask: LocalTask {
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
                    scheme: "BlackBoxUiTests",
                    workspaceName: "Tests",
                    destination: destinationForBuilding
                )
            },
            artifacts: { iosBuildArtifactsProvider in
                try iosBuildArtifactsProvider.iosUiTests(
                    appName: "TestedApp.app",
                    testsTarget: "BlackBoxUiTests",
                    additionalApps: ["FakeSettingsApp.app"]
                )
            },
            additionalEnvironment: [:]
        )
    }
}
