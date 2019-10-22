import MixboxUiTestsFoundation
import XCTest

// Test verifies that testing framework is tolerant to changes of hierarchy within
// some time interval. For example, if it doesn't see the view it waits.
//
// We experienced bugs with some iOS version (9, 10 or 11) and just recently on iOS 12.
// When XCUIElement (was XCUIApplication) was instantiated and stored into a variable
// and then we used it to find elements with predicate it was iterating some element snapshots,
// then UI was changed, but element snapshot were not. The solution was in instantiating XCUIApplication
// for every query.
final class SituationsWhereHierarchyIsChangedOverTimeAreHandledProperlyTests: TestCase {
    override func precondition() {
        super.precondition()
        
        openScreen(name: "ChangingHierarchyTestsView")
        
        // Wait & check UI:
        
        let elementAsserts: [(Screen) -> ElementWithUi] = [
            { $0.duplicatedView0 },
            { $0.duplicatedView1 },
            { $0.duplicatedView.any },
            { $0.hiddenButton },
            { $0.frameButton },
            { $0.alphaButton },
            { $0.progressIndicator }
        ]
        
        for screen in [pageObjects.xcui, pageObjects.real] {
            for element in elementAsserts {
                element(screen).assertIsDisplayed()
            }
        }
    }
    
    func test_hidden_mainUiKitHierarchy() {
        parameterizedTest(
            button: { $0.hiddenButton },
            screen: pageObjects.real
        )
    }
    
    func test_alpha_mainUiKitHierarchy() {
        parameterizedTest(
            button: { $0.alphaButton },
            screen: pageObjects.real
        )
    }
    
    func test_hidden_xcui() {
        parameterizedTest(
            button: { $0.hiddenButton },
            screen: pageObjects.xcui
        )
    }
    
    func test_alpha_xcui() {
        parameterizedTest(
            button: { $0.alphaButton },
            screen: pageObjects.xcui
        )
    }
    
    // Note that element with zero frame disappears from XCUI hierarchy.
    // We did not make this behavior for real hierarchy
    // (intentionally; TODO: fix problems with tapping elements with zero frame).
    func test_frame() {
        parameterizedTest(
            button: { $0.frameButton },
            screen: pageObjects.xcui
        )
    }
    
    private func parameterizedTest(
        button buttonClosure: (Screen) -> ButtonElement,
        screen: Screen)
    {
        let button = buttonClosure(screen)
        
        screen.progressIndicator.assertHasText("Ready")
        
        assertFails {
            // Multiple matches
            screen.duplicatedView.withoutTimeout.assertIsDisplayed()
        }
        
        screen.duplicatedView0.withoutTimeout.assertIsDisplayed()
        screen.duplicatedView1.withoutTimeout.assertIsDisplayed()
        
        button.tap()
        
        // Check if test is correct:
        screen.progressIndicator.assertHasText("Idling")
        
        assertFails {
            // Multiple matches
            screen.duplicatedView.withoutTimeout.assertIsDisplayed()
        }
        
        // Will wait until condition is met
        screen.duplicatedView.assertIsDisplayed()
        
        screen.resetButton.tap()
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    var duplicatedView: ViewElement {
        return element("duplicatedView") {
            $0.id == "duplicatedView"
        }
    }
    
    var duplicatedView0: ViewElement {
        return element("duplicatedView") {
            $0.id == "duplicatedView" && $0.customValues["index"] == 0
        }
    }
    
    var duplicatedView1: ViewElement {
        return element("duplicatedView") {
            $0.id == "duplicatedView" && $0.customValues["index"] == 1
        }
    }
    
    var resetButton: ButtonElement {
        return button("Reset")
    }
    
    var hiddenButton: ButtonElement {
        return button("Hidden")
    }
    
    var alphaButton: ButtonElement {
        return button("Alpha")
    }
    
    var frameButton: ButtonElement {
        return button("Frame")
    }
    
    var progressIndicator: LabelElement {
        return element("progressIndicator") {
            $0.id == "progressIndicator"
        }
    }
    
    private func button(_ text: String) -> ButtonElement {
        return element("\(text) button") { $0.id == "\(text)-button" }
    }
}

private extension PageObjects {
    var real: Screen {
        return apps.mainUiKitHierarchy.pageObject()
    }
    var xcui: Screen {
        return apps.mainXcuiHierarchy.pageObject()
    }
}
 
