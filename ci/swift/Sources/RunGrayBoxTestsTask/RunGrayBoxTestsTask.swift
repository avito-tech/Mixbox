import Tasks
import TestRunning
import SingletonHell

public final class RunGrayBoxTestsTask: LocalTask {
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
                    scheme: "GrayBoxUiTests",
                    workspaceName: "Tests",
                    destination: destinationForBuilding
                )
            },
            artifacts: { iosBuildArtifactsProvider in
                try iosBuildArtifactsProvider.iosApplicationTests(
                    appName: "TestedApp.app",
                    testsTarget: "GrayBoxUiTests"
                )
            },
            additionalEnvironment: [
                Env.MIXBOX_IPC_STARTER_TYPE.rawValue: "graybox"
            ]
        )
    }
}
