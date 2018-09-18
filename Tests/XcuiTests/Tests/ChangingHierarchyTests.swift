import MixboxUiTestsFoundation
import XCTest

final class ChangingHierarchyTests: TestCase {
    override func precondition() {
        openScreen(name: "ChangingHierarchyTestsView")
        
        // Wait & check UI:
        
        let elementAsserts: [(Screen) -> Element & ViewElementChecks] = [
            { $0.duplicatedView0.assert },
            { $0.duplicatedView1.assert },
            { $0.duplicatedView.any.assert },
            { $0.hiddenButton.assert },
            { $0.frameButton.assert },
            { $0.alphaButton.assert },
            { $0.progressIndicator.assert }
        ]
        
        for screen in [pageObjects.xcui, pageObjects.real] {
            for element in elementAsserts {
                element(screen).isDisplayed()
            }
        }
    }
    
    func test_hidden_mainRealHierarchy() {
        parameterizedTest(
            button: { $0.hiddenButton },
            screen: pageObjects.real
        )
    }
    
    func test_alpha_mainRealHierarchy() {
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
        
        screen.progressIndicator.assert.hasText("Ready")
        
        assertFails {
            // Multiple matches
            screen.duplicatedView.withoutTimeout.assert.isDisplayed()
        }
        
        screen.duplicatedView0.withoutTimeout.assert.isDisplayed()
        screen.duplicatedView1.withoutTimeout.assert.isDisplayed()
        
        button.tap()
        
        // Check if test is correct:
        screen.progressIndicator.withoutTimeout.assert.hasText("Idling")
        assertFails {
            // Multiple matches
            screen.duplicatedView.withoutTimeout.assert.isDisplayed()
        }
        screen.progressIndicator.withoutTimeout.assert.hasText("Idling")
        
        // Will wait until condition is met
        screen.duplicatedView.assert.isDisplayed()
        
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
        return apps.mainRealHierarchy.pageObject()
    }
    var xcui: Screen {
        return apps.mainXcui.pageObject()
    }
}
