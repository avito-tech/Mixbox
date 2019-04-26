// Mimics XCUICoordinate & XCUIElement interfaces.
//
// Except for this function:
//
//     press(duration: TimeInterval, thenDragToCoordinate: XCUICoordinate OR XCUIElement)
//
// TODO: Can it be completely replaced with EventsGenerator? Anyway, gestures are too limited now. We should use
// more customizable things.
public protocol ElementSimpleGestures: class {
    func tap() throws
    func doubleTap()
    func press(duration: TimeInterval)
}
