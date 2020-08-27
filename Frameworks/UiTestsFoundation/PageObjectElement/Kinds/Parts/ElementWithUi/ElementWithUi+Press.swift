import MixboxFoundation
import MixboxIpcCommon
import UIKit

extension ElementWithUi {
    @discardableResult
    public func press(
        duration: Double = 0.5,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = PressAction(
            duration: duration,
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
