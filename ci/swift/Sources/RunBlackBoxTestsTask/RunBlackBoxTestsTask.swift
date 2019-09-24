import Bash
import Foundation
import CiFoundation
import Tasks
import SingletonHell
import Emcee
import Destinations

public final class RunBlackBoxTestsTask: LocalTask {
    public let name = "RunBlackBoxTestsTask"
    
    private let bashExecutor: BashExecutor
    private let blackBoxTestRunner: BlackBoxTestRunner
    private let mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider
    
    public init(
        bashExecutor: BashExecutor,
        blackBoxTestRunner: BlackBoxTestRunner,
        mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider)
    {
        self.bashExecutor = bashExecutor
        self.blackBoxTestRunner = blackBoxTestRunner
        self.mixboxTestDestinationConfigurationsProvider = mixboxTestDestinationConfigurationsProvider
    }
    
    public func execute() throws {
        try Prepare.prepareForIosTesting(rebootSimulator: false)
        
        try BuildUtils.buildIos(
            folder: "Tests",
            action: "build-for-testing",
            scheme: "BlackBoxUiTests",
            workspace: "Tests",
            xcodeDestination: try DestinationUtils.xcodeDestination(),
            xcodebuildPipeFilter: "xcpretty"
        )
        
        try test(
            appName: "TestedApp.app",
            testsTarget: "BlackBoxUiTests",
            additionalApp: "FakeSettingsApp.app"
        )
        
        try Cleanup.cleanUpAfterIosTesting()
    }
    
    private func test(
        appName: String,
        testsTarget: String,
        additionalApp: String)
        throws
    {
        let runnerAppName = "\(testsTarget)-Runner.app"
        let derivedDataPath = Variables.derivedDataPath()
        
        let products = "\(derivedDataPath)/Build/Products/Debug-iphonesimulator"
        
        let xctestBundle = "\(products)/\(testsTarget)-Runner.app/PlugIns/\(testsTarget).xctest"
        let runnerPath = "\(products)/\(runnerAppName)"
        let appPath = "\(products)/\(appName)"
        let additionalAppPath = "\(products)/\(additionalApp)"
        
        try blackBoxTestRunner.runTests(
            xctestBundle: xctestBundle,
            runnerPath: runnerPath,
            appPath: appPath,
            additionalAppPaths: [additionalAppPath],
            mixboxTestDestinationConfigurations: try mixboxTestDestinationConfigurationsProvider
                .mixboxTestDestinationConfigurations()
        )
    }
}
