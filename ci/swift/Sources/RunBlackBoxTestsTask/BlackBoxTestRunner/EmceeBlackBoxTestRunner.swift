import Emcee
import Foundation
import CiFoundation
import Bash
import SingletonHell
import RemoteFiles
import Destinations

public final class EmceeBlackBoxTestRunner: BlackBoxTestRunner {
    private let emceeProvider: EmceeProvider
    private let temporaryFileProvider: TemporaryFileProvider
    private let bashExecutor: BashExecutor
    private let queueServerRunConfigurationUrl: URL
    private let sharedQueueDeploymentDestinationsUrl: URL
    private let testArgFileJsonGenerator: TestArgFileJsonGenerator
    private let fileDownloader: FileDownloader
    private let environmentProvider: EnvironmentProvider
    
    public init(
        emceeProvider: EmceeProvider,
        temporaryFileProvider: TemporaryFileProvider,
        bashExecutor: BashExecutor,
        queueServerRunConfigurationUrl: URL,
        sharedQueueDeploymentDestinationsUrl: URL,
        testArgFileJsonGenerator: TestArgFileJsonGenerator,
        fileDownloader: FileDownloader,
        environmentProvider: EnvironmentProvider)
    {
        self.emceeProvider = emceeProvider
        self.temporaryFileProvider = temporaryFileProvider
        self.bashExecutor = bashExecutor
        self.queueServerRunConfigurationUrl = queueServerRunConfigurationUrl
        self.sharedQueueDeploymentDestinationsUrl = sharedQueueDeploymentDestinationsUrl
        self.testArgFileJsonGenerator = testArgFileJsonGenerator
        self.fileDownloader = fileDownloader
        self.environmentProvider = environmentProvider
    }
    
    public func runTests(
        xctestBundle: String,
        runnerPath: String,
        appPath: String,
        additionalAppPaths: [String],
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration])
        throws
    {
        let emcee = try emceeProvider.emcee()
        
        let reportsPath = try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_REPORTS_PATH)
        let junit = "\(reportsPath)/junit.xml"
        let trace = "\(reportsPath)/trace.json"
        
        try emcee.runTestsOnRemoteQueue(
            arguments: EmceeRunTestsOnRemoteQueueCommandArguments(
                jobId: UUID().uuidString,
                testArgFile: testArgFile(
                    mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations,
                    xctestBundle: xctestBundle,
                    runnerPath: runnerPath,
                    appPath: appPath,
                    additionalAppPaths: additionalAppPaths,
                    priority: 500
                ),
                queueServerDestination: fileDownloader.download(url: sharedQueueDeploymentDestinationsUrl),
                queueServerRunConfigurationLocation: queueServerRunConfigurationUrl.absoluteString,
                tempFolder: temporaryFileProvider.temporaryFilePath(),
                junit: junit,
                trace: trace
            )
        )
    }
    
    private func testArgFile(
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        xctestBundle: String,
        runnerPath: String,
        appPath: String,
        additionalAppPaths: [String],
        priority: UInt)
        throws
        -> String
    {
        return try testArgFileJsonGenerator.testArgFile(
            arguments: TestArgFileGeneratorArguments(
                runnerPath: runnerPath,
                appPath: appPath,
                additionalAppPaths: additionalAppPaths,
                xctestBundlePath: xctestBundle,
                mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations,
                environment: environment(),
                testType: .uiTest,
                testDiscoveryMode: .runtimeLogicTest,
                priority: priority
            )
        )
    }
    
    private func environment() -> [String: String] {
        var environment = [
            Env.MIXBOX_CI_USES_FBXCTEST.rawValue: "true",
            Env.MIXBOX_CI_IS_CI_BUILD.rawValue: "true"
        ]
        
        environment[Env.MIXBOX_CI_GRAPHITE_HOST.rawValue] = environmentProvider.environment[Env.MIXBOX_CI_GRAPHITE_HOST.rawValue]
        environment[Env.MIXBOX_CI_GRAPHITE_PORT.rawValue] = environmentProvider.environment[Env.MIXBOX_CI_GRAPHITE_PORT.rawValue]
        environment[Env.MIXBOX_CI_GRAPHITE_PREFIX.rawValue] = environmentProvider.environment[Env.MIXBOX_CI_GRAPHITE_PREFIX.rawValue]
        
        return environment
    }
}
