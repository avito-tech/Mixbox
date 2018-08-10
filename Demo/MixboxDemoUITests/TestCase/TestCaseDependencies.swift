import SBTUITestTunnel
import MixboxXcuiDriver
import MixboxIpcSbtuiClient
import MixboxReporting
import MixboxUiTestsFoundation

final class TestCaseDependencies {
    let application = SBTUITunneledApplication()
    let pageObjects: PageObjects
    
    init() {
        let currentTestCaseProvider = CurrentTestCaseProviderImpl()
        let screenshotTaker = XcuiScreenshotTaker()
        let stepLogger = XcuiActivityStepLogger(originalStepLogger: StepLoggerImpl())
        let snapshotsComparisonUtility = SnapshotsComparisonUtilityImpl(
            // TODO
            basePath: "/tmp/35B74059-CF04-4679-853C-9B6C961BDAA8/UITests/Screenshots"
        )
        
        pageObjects = PageObjects(
            pageObjectsDependenciesFactory: XcuiPageObjectsDependenciesFactory(
                interactionExecutionLogger: InteractionExecutionLoggerImpl(
                    stepLogger: stepLogger,
                    screenshotTaker: screenshotTaker
                ),
                testFailureRecorder: XcTestFailureRecorder(
                    currentTestCaseProvider: currentTestCaseProvider
                ),
                ipcClient: SbtuiIpcClient(
                    application: application
                ),
                snapshotsComparisonUtility: snapshotsComparisonUtility,
                stepLogger: stepLogger
            )
        )
    }
}
