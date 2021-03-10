import MixboxFoundation
import MixboxIpcCommon
import UIKit
extension ElementWithUi {
    @discardableResult
    public func tap(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = TapAction(
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
