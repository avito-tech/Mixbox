import Emcee
import Foundation
import CiFoundation
import Bash
import SingletonHell
import RemoteFiles
import Destinations
import BuildArtifacts
import ResourceLocation

public final class EmceeTestRunner: TestRunner {
    private let emceeProvider: EmceeProvider
    private let temporaryFileProvider: TemporaryFileProvider
    private let bashExecutor: BashExecutor
    private let queueServerRunConfigurationUrl: URL
    private let testArgFileJsonGenerator: TestArgFileJsonGenerator
    private let fileDownloader: FileDownloader
    private let environmentProvider: EnvironmentProvider
    
    public init(
        emceeProvider: EmceeProvider,
        temporaryFileProvider: TemporaryFileProvider,
        bashExecutor: BashExecutor,
        queueServerRunConfigurationUrl: URL,
        testArgFileJsonGenerator: TestArgFileJsonGenerator,
        fileDownloader: FileDownloader,
        environmentProvider: EnvironmentProvider)
    {
        self.emceeProvider = emceeProvider
        self.temporaryFileProvider = temporaryFileProvider
        self.bashExecutor = bashExecutor
        self.queueServerRunConfigurationUrl = queueServerRunConfigurationUrl
        self.testArgFileJsonGenerator = testArgFileJsonGenerator
        self.fileDownloader = fileDownloader
        self.environmentProvider = environmentProvider
    }
    
    public func runTests(
        iosBuildArtifacts: IosBuildArtifacts,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        additionalEnvironment: [String: String]
    ) throws {
        let emcee = try emceeProvider.emcee()
        
        let reportsPath = try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_REPORTS_PATH)
        let junit = "\(reportsPath)/junit.xml"
        let trace = "\(reportsPath)/trace.json"
        
        try emcee.runTestsOnRemoteQueue(
            arguments: EmceeRunTestsOnRemoteQueueCommandArguments(
                jobId: UUID().uuidString,
                testArgFile: testArgFile(
                    iosBuildArtifacts: iosBuildArtifacts,
                    mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations,
                    priority: 500,
                    additionalEnvironment: additionalEnvironment
                ),
                queueServerRunConfigurationLocation: queueServerRunConfigurationUrl.absoluteString,
                tempFolder: temporaryFileProvider.temporaryFilePath(),
                junit: junit,
                trace: trace
            )
        )
    }
    
    private func testArgFile(
        iosBuildArtifacts: IosBuildArtifacts,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        priority: UInt,
        additionalEnvironment: [String: String]
    ) throws -> String {
        return try testArgFileJsonGenerator.testArgFile(
            arguments: TestArgFileGeneratorArguments(
                iosBuildArtifacts: iosBuildArtifacts,
                mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations,
                environment: environment(
                    additionalEnvironment: additionalEnvironment
                ),
                priority: priority
            )
        )
    }
    
    private func environment(
        additionalEnvironment: [String: String]
    ) -> [String: String] {
        var environment = [
            Env.MIXBOX_CI_USES_FBXCTEST.rawValue: "true",
            Env.MIXBOX_CI_IS_CI_BUILD.rawValue: "true"
        ]
        
        environment[Env.MIXBOX_CI_GRAPHITE_HOST.rawValue] = environmentProvider.environment[Env.MIXBOX_CI_GRAPHITE_HOST.rawValue]
        environment[Env.MIXBOX_CI_GRAPHITE_PORT.rawValue] = environmentProvider.environment[Env.MIXBOX_CI_GRAPHITE_PORT.rawValue]
        environment[Env.MIXBOX_CI_GRAPHITE_PREFIX.rawValue] = environmentProvider.environment[Env.MIXBOX_CI_GRAPHITE_PREFIX.rawValue]
        
        environment.merge(
            additionalEnvironment,
            uniquingKeysWith: { old, additional in
                additional
            }
        )
        
        return environment
    }
}
