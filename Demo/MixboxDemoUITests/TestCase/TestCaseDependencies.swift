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
        let applicationProvider = ApplicationProviderImpl { XCUIApplication() }
        let ipcClient = SbtuiIpcClient(
            application: application
        )
        
        let spinner: Spinner = SpinnerImpl(
            runLoopSpinnerFactory: RunLoopSpinnerFactoryImpl(
                runLoopModesStackProvider: RunLoopModesStackProviderImpl()
            )
        )
        
        pageObjects = PageObjects(
            pageObjectDependenciesFactory: XcuiPageObjectDependenciesFactory(
                testFailureRecorder: XcTestFailureRecorder(
                    currentTestCaseProvider: currentTestCaseProvider
                ),
                ipcClient: ipcClient,
                stepLogger: stepLogger,
                pollingConfiguration: .reduceWorkload,
                elementFinder:
                XcuiElementFinder(
                    stepLogger: stepLogger,
                    applicationProviderThatDropsCaches: applicationProvider,
                    screenshotTaker: XcuiScreenshotTaker()
                ),
                applicationProvider: applicationProvider,
                eventGenerator: XcuiEventGenerator(
                    applicationProvider: applicationProvider
                ),
                screenshotTaker: screenshotTaker,
                pasteboard: IpcPasteboard(ipcClient: ipcClient),
                spinner: spinner
            )
        )
    }
}
