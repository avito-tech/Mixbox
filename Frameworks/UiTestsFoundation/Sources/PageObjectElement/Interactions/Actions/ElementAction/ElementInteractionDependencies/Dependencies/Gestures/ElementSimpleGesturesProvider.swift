import UIKit

public protocol ElementSimpleGesturesProvider: AnyObject {
    func elementSimpleGestures(
        elementSnapshot: ElementSnapshot,
        pointOnScreen: CGPoint)
        throws
        -> ElementSimpleGestures
}
