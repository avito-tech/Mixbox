import MixboxUiTestsFoundation
import XCTest

final class InteractionFailureMaker {
    static func interactionFailure(
        message: String,
        elementFindingFailure: String? = nil,
        currentElementSnapshots: [ElementSnapshot]? = nil,
        interactionSpecificFailure: InteractionSpecificFailure? = nil)
        -> InteractionFailure
    {
        var betterUiHierarchy: String?
        
        if let currentElementSnapshots = currentElementSnapshots {
            betterUiHierarchy = self.betterUiHierarchy(
                currentElementSnapshots: currentElementSnapshots
            )
        }
        
        let application = XCUIApplication()
        let applicationUiHierarchy = application.exists ? application.debugDescription : nil
        
        return InteractionFailure(
            message: message,
            error: elementFindingFailure.flatMap(error),
            screenshotAtFailure: XcuiScreenshotTaker().takeScreenshot(),
            applicationUiHierarchy: applicationUiHierarchy,
            betterUiHierarchy: betterUiHierarchy,
            stackTrace: Thread.callStackSymbols,
            testCaseName: nil,
            testMethodName: nil,
            interactionSpecificFailure: interactionSpecificFailure
        )
    }
    
    private static func error(elementFindingFailure: String) -> NSError {
        let message = "Не удалось найти элемент. Сравните иерархию и ошибки по элементам:\n" + elementFindingFailure
        
        let error = NSError(
            domain: NSError.currentFrameworkDomain,
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey: message
            ]
        )
        
        return error
    }
    
    private static func betterUiHierarchy(currentElementSnapshots: [ElementSnapshot]) -> String {
        return "(Отключено из-за проблем с производительностью, включайте в коде, если нужно)"
        /*return currentElementSnapshots
            .map { snapshot in snapshot.debugDescription }
            .joined(separator: "\n")*/
    }
}
