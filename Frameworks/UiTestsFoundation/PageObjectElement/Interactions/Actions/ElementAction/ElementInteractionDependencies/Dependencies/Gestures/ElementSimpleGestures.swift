// Mimics XCUICoordinate & XCUIElement interfaces.
//
// Except for this function:
//
//     press(duration: TimeInterval, thenDragToCoordinate: XCUICoordinate OR XCUIElement)
//
// TODO: Can it be completely replaced with EventsGenerator? Anyway, gestures are too limited now. We should use
// more customizable things.
import Foundation
import UIKit

public protocol ElementSimpleGestures: class {
    func tap() throws
    func press(duration: TimeInterval) throws
}
