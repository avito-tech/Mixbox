import Emcee
import Foundation
import CiFoundation
import Bash
import SingletonHell
import Models
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
        
        let fbxctestUrlString = try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_EMCEE_FBXCTEST_URL)
        
        let reportsPath = try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_REPORTS_PATH)
        let junit = "\(reportsPath)/junit.xml"
        let trace = "\(reportsPath)/trace.json"
        
        try emcee.runTestsOnRemoteQueue(
            arguments: EmceeRunTestsOnRemoteQueueCommandArguments(
                runId: UUID().uuidString,
                testArgFile: testArgFile(
                    mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations,
                    fbxctestUrlString: fbxctestUrlString,
                    xctestBundle: xctestBundle,
                    runnerPath: runnerPath,
                    appPath: appPath,
                    additionalAppPaths: additionalAppPaths,
                    priority: 500
                ),
                queueServerDestination: fileDownloader.download(url: sharedQueueDeploymentDestinationsUrl),
                queueServerRunConfigurationLocation: queueServerRunConfigurationUrl.absoluteString,
                tempFolder: temporaryFileProvider.temporaryFilePath(),
                fbxctest: fbxctestUrlString,
                junit: junit,
                trace: trace,
                fbsimctl: try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_EMCEE_FBSIMCTL_URL)
            )
        )
    }
    
    private func testArgFile(
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        fbxctestUrlString: String,
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
                fbsimctlUrl: try URL.from(
                    string: try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_EMCEE_FBSIMCTL_URL)
                ),
                fbxctestUrl: try URL.from(
                    string: fbxctestUrlString
                ),
                mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations,
                environment: environment(),
                testType: .uiTest,
                runtimeDumpKind: .logicTest,
                priority: priority
            )
        )
    }
    
    private func environment() -> [String: String] {
        return [
            "MIXBOX_CI_USES_FBXCTEST": "true",
            "MIXBOX_CI_IS_CI_BUILD": "true"
        ]
    }
}
