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

@objcMembers class Kludge {
    // This is not something required for Mixbox. We use it on many projects without the following kludge.
    // It seems that something is wrong with demo project and it should be remade.
    // Maybe we just have `print()` in our project, I don't know. It doesn't reproduce in Xcode 10.2.1 (and maybe later)
    //
    // Note that is is only one way to fix an issue (the most vivid) and it is given for example.
    // See other options here: https://stackoverflow.com/questions/40986082/dyld-library-not-loaded-rpath-libswiftswiftononesupport-dylib
    //
    // Note that you should try not to use this kludge, there is a great chance everythin will work without it.
    private func thisFunctionIsNotUsedButEventuallyFixesCrash() {
        // This line fixes crash:
        //
        // 2019-02-26 00:34:33.020685+0300 MixboxDemoUITests-Runner[61838:18544173] (dlopen_preflight(/Users/razinov/Library/Developer/Xcode/DerivedData/MixboxDemo-fpcsjryqkqkzcwdqcjtpfaotnztn/Build/Products/Debug-iphonesimulator/MixboxDemoUITests-Runner.app/PlugIns/MixboxDemoUITests.xctest/MixboxDemoUITests): Library not loaded: @rpath/libswiftSwiftOnoneSupport.dylib
        // Referenced from: /Users/razinov/Library/Developer/Xcode/DerivedData/MixboxDemo-fpcsjryqkqkzcwdqcjtpfaotnztn/Build/Products/Debug-iphonesimulator/MixboxDemoUITests-Runner.app/PlugIns/MixboxDemoUITests.xctest/Frameworks/MixboxArtifacts.framework/MixboxArtifacts
        // Reason: image not found)
        //
        print("")
    }
}
