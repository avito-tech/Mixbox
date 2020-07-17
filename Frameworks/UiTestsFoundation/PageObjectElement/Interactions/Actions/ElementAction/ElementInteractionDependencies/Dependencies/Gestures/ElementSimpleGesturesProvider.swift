public protocol ElementSimpleGesturesProvider: class {
    func elementSimpleGestures(
        elementSnapshot: ElementSnapshot,
        pointOnScreen: CGPoint)
        throws
        -> ElementSimpleGestures
}
