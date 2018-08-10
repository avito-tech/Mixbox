import SBTUITestTunnel
import MixboxReporting
import MixboxXcuiDriver
import MixboxUiTestsFoundation
import MixboxIpcSbtuiClient

// Сборник утилок для TestCase с их настройками. Может сильно вырасти.
final class TestCaseUtils {
    // Internal in TestCase
    
    let pageObjects: PageObjects
    
    // Private in TestCase
    
    let currentTestCaseProvider = CurrentTestCaseProviderImpl()
    let testFailureRecorder: TestFailureRecorder
    let lazilyInitializedIpcClient = LazilyInitializedIpcClient()
    
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let screenshotTaker = XcuiScreenshotTaker()
    private let stepLogger = XcuiActivityStepLogger(originalStepLogger: StepLoggerImpl())
    
    init() {
        testFailureRecorder = XcTestFailureRecorder(
            currentTestCaseProvider: currentTestCaseProvider
        )
        
        interactionExecutionLogger = InteractionExecutionLoggerImpl(
            stepLogger: stepLogger,
            screenshotTaker: screenshotTaker
        )
        
        let snapshotsComparisonUtility = SnapshotsComparisonUtilityImpl(
            // TODO
            basePath: "/tmp/01A2DABE-6D10-45D7-B48E-4AC1153712A9/UITests/Screenshots"
        )
        
        pageObjects = PageObjects(
            pageObjectsDependenciesFactory: XcuiPageObjectsDependenciesFactory(
                interactionExecutionLogger: interactionExecutionLogger,
                testFailureRecorder: testFailureRecorder,
                ipcClient: lazilyInitializedIpcClient,
                snapshotsComparisonUtility: snapshotsComparisonUtility,
                stepLogger: stepLogger
            )
        )
    }
}
