import Emcee
import Foundation
import CiFoundation
import Bash
import SingletonHell

public final class EmceeGrayBoxTestRunner: GrayBoxTestRunner {
    private let emceeProvider: EmceeProvider
    private let temporaryFileProvider: TemporaryFileProvider
    private let bashExecutor: BashExecutor
    private let queueServerRunConfigurationUrl: String
    private let sharedQueueDeploymentDestinationsUrl: String
    private let workerDeploymentDestinationsUrl: String
    
    public init(
        emceeProvider: EmceeProvider,
        temporaryFileProvider: TemporaryFileProvider,
        bashExecutor: BashExecutor,
        queueServerRunConfigurationUrl: String,
        sharedQueueDeploymentDestinationsUrl: String,
        workerDeploymentDestinationsUrl: String)
    {
        self.emceeProvider = emceeProvider
        self.temporaryFileProvider = temporaryFileProvider
        self.bashExecutor = bashExecutor
        self.queueServerRunConfigurationUrl = queueServerRunConfigurationUrl
        self.sharedQueueDeploymentDestinationsUrl = sharedQueueDeploymentDestinationsUrl
        self.workerDeploymentDestinationsUrl = workerDeploymentDestinationsUrl
    }
    
    public func runTests(
        xctestBundle: String,
        appPath: String)
        throws
    {
        let emcee = try emceeProvider.emcee()
        
        let fbxctestUrl = try Env.MIXBOX_CI_EMCEE_FBXCTEST_URL.getOrThrow()
        
        let reportsPath = try Env.MIXBOX_CI_REPORTS_PATH.getOrThrow()
        let junit = "\(reportsPath)/junit.xml"
        let trace = "\(reportsPath)/trace.json"
        
        let testDestinationConfigurationJsonPath = try DestinationUtils.destinationFile()
        
        try emcee.runTestsOnRemoteQueue(
            arguments: EmceeRunTestsOnRemoteQueueCommandArguments(
                priority: 500,
                runId: uuidgen(),
                destinations: try RemoteFiles.download(url: workerDeploymentDestinationsUrl),
                testArgFile: EmceeUtils.testArgsFile(
                    emcee: emcee,
                    temporaryFileProvider: temporaryFileProvider,
                    appPath: appPath,
                    fbsimctlUrl: Env.MIXBOX_CI_EMCEE_FBSIMCTL_URL.getOrThrow(),
                    xctestBundlePath: xctestBundle,
                    fbxctestUrl: fbxctestUrl,
                    testDestinationConfigurationJsonPath: testDestinationConfigurationJsonPath,
                    environmentJson: "\(try repoRoot())/ci/builds/emcee/gray_box_environment.json",
                    testType: .appTest
                ),
                queueServerDestination: try RemoteFiles.download(url: sharedQueueDeploymentDestinationsUrl),
                queueServerRunConfigurationLocation: queueServerRunConfigurationUrl,
                runner: nil,
                app: try RemoteFiles.upload_hashed_zipped_for_emcee(file: appPath),
                additionalApps: [],
                xctestBundle: try RemoteFiles.upload_hashed_zipped_for_emcee(file: xctestBundle),
                fbxctest: fbxctestUrl,
                junit: junit,
                trace: trace,
                testDestinations: testDestinationConfigurationJsonPath,
                fbsimctl: Env.MIXBOX_CI_EMCEE_FBSIMCTL_URL.getOrThrow()
            )
        )
    }
}
