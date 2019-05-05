import MixboxUiTestsFoundation

final class ActionSpecifications {
    // Open-Closed principle is violated due to testcase, when random series of actions is tested.
    // Every new action should be tested if it affects other action.
    // TODO: How to detect if some action is not tested thoroughly?
    
    static let tap = ActionSpecification<ButtonElement>(
        elementId: "tap",
        action: { $0.tap() },
        expectedResult: "tap"
    )
    
    static let press = ActionSpecification<ButtonElement>(
        elementId: "press",
        action: { $0.press(duration: 1.2) },
        expectedResult: "press"
    )
    
    static func setText(
        text: String,
        inputMethod: SetTextActionFactory.InputMethod? = nil)
        -> ActionSpecification<InputElement>
    {
        return ActionSpecification(
            elementId: "text",
            action: { element in
                if let inputMethod = inputMethod {
                    element.setText(text, inputMethod: inputMethod)
                } else {
                    element.setText(text)
                }
            },
            expectedResult: "text: \(text)"
        )
    }
    
    static let clearText = ActionSpecification<InputElement>(
        elementId: "text",
        action: { element in
            element.setText("Введенная строка")
            element.clearText()
        },
        expectedResult: "text: "
    )
    
    static let swipeUp = ActionSpecification<LabelElement>(
        elementId: "swipeUp",
        action: { $0.swipeUp() },
        expectedResult: "swipeUp"
    )
    
    static let swipeDown = ActionSpecification<LabelElement>(
        elementId: "swipeDown",
        action: { $0.swipeDown() },
        expectedResult: "swipeDown"
    )
    
    static let swipeLeft = ActionSpecification<LabelElement>(
        elementId: "swipeLeft",
        action: { $0.swipeLeft() },
        expectedResult: "swipeLeft"
    )
    
    static let swipeRight = ActionSpecification<LabelElement>(
        elementId: "swipeRight",
        action: { $0.swipeRight() },
        expectedResult: "swipeRight"
    )
    
    static var all: [AnyActionSpecification] {
        let text = "Text that is set"
        
        return [
            tap,
            press,
            setText(text: text, inputMethod: .paste),
            // TODO: Fix, pasting is flaky
            // setText(text: text, inputMethod: .pasteUsingPopupMenus),
            setText(text: text, inputMethod: .type),
            swipeUp,
            swipeDown,
            swipeLeft,
            swipeRight
        ]
    }
}
