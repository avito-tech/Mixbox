import Bash
import Foundation
import CiFoundation
import Tasks
import SingletonHell
import Emcee
import Destinations

public final class RunGrayBoxTestsTask: LocalTask {
    public let name = "RunGrayBoxTestsTask"
    
    private let bashExecutor: BashExecutor
    private let grayBoxTestRunner: GrayBoxTestRunner
    private let mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider
    
    public init(
        bashExecutor: BashExecutor,
        grayBoxTestRunner: GrayBoxTestRunner,
        mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider)
    {
        self.bashExecutor = bashExecutor
        self.grayBoxTestRunner = grayBoxTestRunner
        self.mixboxTestDestinationConfigurationsProvider = mixboxTestDestinationConfigurationsProvider
    }
    
    public func execute() throws {
        try Prepare.prepareForIosTesting(rebootSimulator: false)
        
        try BuildUtils.buildIos(
            folder: "Tests",
            action: "build-for-testing",
            scheme: "GrayBoxUiTests",
            workspace: "Tests",
            xcodeDestination: try DestinationUtils.xcodeDestination(),
            xcodebuildPipeFilter: "xcpretty"
        )
        
        try test(
            appName: "TestedApp.app",
            testsTarget: "GrayBoxUiTests"
        )
        
        try Cleanup.cleanUpAfterIosTesting()
    }
    
    private func test(
        appName: String,
        testsTarget: String)
        throws
    {
        let derivedDataPath = Variables.derivedDataPath()
        
        let products = "\(derivedDataPath)/Build/Products/Debug-iphonesimulator"
        
        let appPath = "\(products)/\(appName)"
        let xctestBundle = "\(appPath)/PlugIns/\(testsTarget).xctest"
        
        try grayBoxTestRunner.runTests(
            xctestBundle: xctestBundle,
            appPath: appPath,
            mixboxTestDestinationConfigurations: try mixboxTestDestinationConfigurationsProvider.mixboxTestDestinationConfigurations()
        )
    }
}
