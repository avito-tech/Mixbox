import Models
import RuntimeDump
import Foundation
import CiFoundation
import Destinations

public final class TestArgFileGeneratorImpl: TestArgFileGenerator {
    private let emceeProvider: EmceeProvider
    private let temporaryFileProvider: TemporaryFileProvider
    private let decodableFromJsonFileLoader: DecodableFromJsonFileLoader
    private let emceeFileUploader: EmceeFileUploader
    private let jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator
    
    public init(
        emceeProvider: EmceeProvider,
        temporaryFileProvider: TemporaryFileProvider,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader,
        emceeFileUploader: EmceeFileUploader,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator)
    {
        self.emceeProvider = emceeProvider
        self.temporaryFileProvider = temporaryFileProvider
        self.decodableFromJsonFileLoader = decodableFromJsonFileLoader
        self.emceeFileUploader = emceeFileUploader
        self.jsonFileFromEncodableGenerator = jsonFileFromEncodableGenerator
    }
    
    public func testArgFile(
        arguments: TestArgFileGeneratorArguments)
        throws
        -> TestArgFile
    {
        let testDestinationConfigurations = try self.testDestinationConfigurations(arguments: arguments)
        
        return try testArgFile(
            testDestinationConfigurations: testDestinationConfigurations,
            testsToRun: testsToRun(
                runtimeDump: try runtimeDump(
                    arguments: arguments,
                    testDestinationConfigurations: testDestinationConfigurations
                )
            ),
            buildArtifacts: try buildArtifacts(arguments: arguments),
            environment: arguments.environment,
            testType: arguments.testType,
            priority: arguments.priority
        )
    }
    
    private func testDestinationConfigurations(
        arguments: TestArgFileGeneratorArguments)
        throws
        -> [TestDestinationConfiguration]
    {
        return try arguments.mixboxTestDestinationConfigurations.map {
            TestDestinationConfiguration(
                testDestination: try TestDestination(
                    deviceType: $0.testDestination.deviceType,
                    runtime: $0.testDestination.iOSVersion
                ),
                reportOutput: Models.ReportOutput(
                    junit: $0.reportOutput.junit,
                    tracingReport: $0.reportOutput.tracingReport
                )
            )
        }
    }
    
    private func testArgFile(
        testDestinationConfigurations: [TestDestinationConfiguration],
        testsToRun: [TestToRun],
        buildArtifacts: BuildArtifacts,
        environment: [String: String],
        testType: TestType,
        priority: UInt)
        throws
        -> TestArgFile
    {
        return TestArgFile(
            entries: testDestinationConfigurations.map { testDestinationConfiguration in
                TestArgFile.Entry(
                    testsToRun: testsToRun,
                    buildArtifacts: buildArtifacts,
                    environment: environment,
                    numberOfRetries: 4,
                    scheduleStrategy: .progressive,
                    testDestination: testDestinationConfiguration.testDestination,
                    testType: testType,
                    toolchainConfiguration: ToolchainConfiguration(
                        developerDir: DeveloperDir.current
                    )
                )
            },
            priority: try Priority(intValue: priority),
            testDestinationConfigurations: testDestinationConfigurations
        )
    }
    
    private func buildArtifacts(
        arguments: TestArgFileGeneratorArguments)
        throws
        -> BuildArtifacts
    {
        return BuildArtifacts(
            appBundle: try upload(path: arguments.appPath),
            runner: try uploadOptional(path: arguments.runnerPath),
            xcTestBundle: XcTestBundle(
                location: try upload(path: arguments.xctestBundlePath),
                runtimeDumpKind: arguments.runtimeDumpKind
            ),
            additionalApplicationBundles: try arguments.additionalAppPaths.map { additionalAppPath in
                try upload(path: additionalAppPath)
            }
        )
    }
    
    private func runtimeDump(
        arguments: TestArgFileGeneratorArguments,
        testDestinationConfigurations: [TestDestinationConfiguration])
        throws
        -> RuntimeDump
    {
        let emcee = try emceeProvider.emcee()
        
        let appPathDumpArgument: String?
        
        switch arguments.runtimeDumpKind {
        case .appTest:
            appPathDumpArgument = arguments.appPath
        case .logicTest:
            appPathDumpArgument = nil
        }
        
        return try emcee.dump(
            arguments: EmceeDumpCommandArguments(
                xctestBundle: arguments.xctestBundlePath,
                fbxctest: arguments.fbxctestUrl.absoluteString,
                testDestinations: jsonFileFromEncodableGenerator.generateJsonFile(
                    encodable: testDestinationConfigurations
                ),
                appPath: appPathDumpArgument,
                fbsimctl: arguments.fbsimctlUrl?.absoluteString,
                tempFolder: temporaryFileProvider.temporaryFilePath()
            )
        )
    }
    
    private func testsToRun(runtimeDump: RuntimeDump) -> [TestToRun] {
        return runtimeDump.runtimeTestEntries.flatMap { runtimeTestEntry in
            runtimeTestEntry.testMethods.map { testMethod in
                TestToRun.testName(
                    TestName(
                        className: runtimeTestEntry.className,
                        methodName: testMethod
                    )
                )
            }
        }
    }
    
    private func upload<T: ResourceLocationType>(
        path: String)
        throws
        -> TypedResourceLocation<T>
    {
        return TypedResourceLocation(
            ResourceLocation.remoteUrl(
                try emceeFileUploader.upload(path: path)
            )
        )
    }
    
    private func uploadOptional<T: ResourceLocationType>(
        path: String?)
        throws
        -> TypedResourceLocation<T>?
    {
        return try path.map(upload)
    }
}
