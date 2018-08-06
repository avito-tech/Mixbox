import EarlGrey
import MixboxUiTestsFoundation

// Maybe we will not use GREYError later.
// We need to check whether GREYError is useful or not,
// because in theory we can grab all data without it.
final class InteractionFailureMaker {
    static func interactionFailure(earlGreyError: NSError) -> InteractionFailure {
        let applicationUiHierarchy: String?
        let stackTrace: [String]
        let testCaseName: String?
        let testMethodName: String?
        
        if let earlGreyError = earlGreyError as? GREYError {
            applicationUiHierarchy = earlGreyError.appUIHierarchy
            stackTrace = earlGreyError.stackTrace as? [String] ?? Thread.callStackSymbols
            testCaseName = earlGreyError.testCaseClassName
            testMethodName = earlGreyError.testCaseMethodName
        } else {
            applicationUiHierarchy = GREYElementHierarchy.hierarchyStringForAllUIWindows()
            stackTrace = Thread.callStackSymbols
            testCaseName = nil
            testMethodName = nil
        }
        
        return InteractionFailure(
            message: earlGreyError.localizedDescription,
            error: earlGreyError,
            screenshotAtFailure: GREYScreenshotUtil.takeScreenshot(),
            applicationUiHierarchy: applicationUiHierarchy,
            stackTrace: stackTrace,
            testCaseName: testCaseName,
            testMethodName: testMethodName
        )
    }
    
    // TODO: Remove copypaste
    static func interactionFailure(message: String) -> InteractionFailure {
        return InteractionFailure(
            message: message,
            error: nil,
            screenshotAtFailure: GREYScreenshotUtil.takeScreenshot(),
            applicationUiHierarchy: GREYElementHierarchy.hierarchyStringForAllUIWindows(),
            stackTrace: Thread.callStackSymbols,
            testCaseName: nil,
            testMethodName: nil
        )
    }
}
