import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest
import TestsIpc
import UIKit

final class CanTapKeyboardTests: TestCase {
    override func precondition() {
        super.precondition()
        
        open(screen: screen)
            .waitUntilViewIsLoaded()
    }
    
    func test() {
        let screen = screen.uikit
        
        for returnKeyType in UIReturnKeyType.allCases {
            resetUi(returnKeyType: returnKeyType)
            
            screen.statusLabel.assertHasText("Initial")
            
            screen.textField.tap()
            screen.doneButton.tap()
            
            screen.statusLabel.assertHasText("Resigned")
        }
    }
    
    private func resetUi(returnKeyType: UIReturnKeyType) {
        resetUi(
            argument: CanTapKeyboardTestsViewConfiguration(
                returnKeyType: returnKeyType
            )
        )
    }
    
    private var screen: MainAppScreen<CanTapKeyboardTestsViewPageObject> {
        return pageObjects.canTapKeyboardTestsView
    }
}
