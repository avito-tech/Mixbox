import SBTUITestTunnel
import MixboxXcuiDriver
import MixboxIpcSbtuiClient
import MixboxReporting
import MixboxTestsFoundation
import MixboxUiTestsFoundation

final class TestCaseDependencies {
    let application = SBTUITunneledApplication()
    let pageObjects: PageObjects
    
    init() {
        let currentTestCaseProvider = AutomaticCurrentTestCaseProvider()
        let screenshotTaker = XcuiScreenshotTaker()
        let stepLogger = XcuiActivityStepLogger(originalStepLogger: StepLoggerImpl())
        let snapshotsComparisonUtility = SnapshotsComparisonUtilityImpl(
            // TODO
            basePath: "/tmp/35B74059-CF04-4679-853C-9B6C961BDAA8/UITests/Screenshots"
        )
        let snapshotCaches = SnapshotCachesImpl.create(cachingEnabled: false)
        let applicationProvider = ApplicationProviderImpl { XCUIApplication() }
        
        pageObjects = PageObjects(
            pageObjectDependenciesFactory: XcuiPageObjectDependenciesFactory(
                interactionExecutionLogger: InteractionExecutionLoggerImpl(
                    stepLogger: stepLogger,
                    screenshotTaker: screenshotTaker,
                    imageHashCalculator: DHashV0ImageHashCalculator()
                ),
                testFailureRecorder: XcTestFailureRecorder(
                    currentTestCaseProvider: currentTestCaseProvider
                ),
                ipcClient: SbtuiIpcClient(
                    application: application
                ),
                snapshotsComparisonUtility: snapshotsComparisonUtility,
                stepLogger: stepLogger,
                pollingConfiguration: .reduceWorkload,
                snapshotCaches: snapshotCaches,
                elementFinder: XcuiElementFinder(
                    stepLogger: stepLogger,
                    snapshotCaches: snapshotCaches,
                    applicationProviderThatDropsCaches: applicationProvider
                ),
                applicationProvider: applicationProvider,
                applicationCoordinatesProvider: ApplicationCoordinatesProviderImpl(applicationProvider: applicationProvider),
                eventGenerator: EventGeneratorImpl(applicationProvider: applicationProvider)
            )
        )
    }
    
    // TODO: Fix without a kludge.
    private func thisFunctionIsNotUsedAnywhereButEventuallyFixesCrash() {
        // This line fixes crash:
        //
        // 2019-02-26 00:34:33.020685+0300 MixboxDemoUITests-Runner[61838:18544173] (dlopen_preflight(/Users/razinov/Library/Developer/Xcode/DerivedData/MixboxDemo-fpcsjryqkqkzcwdqcjtpfaotnztn/Build/Products/Debug-iphonesimulator/MixboxDemoUITests-Runner.app/PlugIns/MixboxDemoUITests.xctest/MixboxDemoUITests): Library not loaded: @rpath/libswiftSwiftOnoneSupport.dylib
        // Referenced from: /Users/razinov/Library/Developer/Xcode/DerivedData/MixboxDemo-fpcsjryqkqkzcwdqcjtpfaotnztn/Build/Products/Debug-iphonesimulator/MixboxDemoUITests-Runner.app/PlugIns/MixboxDemoUITests.xctest/Frameworks/MixboxArtifacts.framework/MixboxArtifacts
        // Reason: image not found)
        //
        // Source: https://stackoverflow.com/questions/40986082/dyld-library-not-loaded-rpath-libswiftswiftononesupport-dylib
        //
        print("")
    }
}
