import MixboxTestsFoundation
import MixboxFoundation
import Foundation
import UIKit

public extension ElementWithText {
    // Makes text be inside text input.
    @discardableResult
    func setText(
        _ text: String,
        elementSelectionMethod: SetTextActionFactory.ElementSelectionMethod = .default,
        inputMethod: SetTextActionFactory.InputMethod = .default,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = SetTextActionFactory.setTextAction(
            text: text,
            elementSelectionMethod: elementSelectionMethod,
            inputMethod: inputMethod,
            textEditingActionMode: .replace,
            interactionCoordinates: InteractionCoordinates(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
        )
        
        return core.perform(
            action: action,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    func clearText(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return setText(
            "",
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    // If you want to just clear text (without storing text to Pasteboard) use clearText instead!
    @discardableResult
    func cutText(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = CutTextAction(
            interactionCoordinates: InteractionCoordinates(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            )
        )
        
        return core.perform(
            action: action,
            failTest: failTest,
            file: file,
            line: line
        )
    }
}
