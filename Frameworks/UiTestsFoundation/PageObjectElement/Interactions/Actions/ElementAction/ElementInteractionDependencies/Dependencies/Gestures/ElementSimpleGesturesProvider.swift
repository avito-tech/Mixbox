public protocol ElementSimpleGesturesProvider: class {
    func elementSimpleGestures(
        elementSnapshot: ElementSnapshot,
        interactionCoordinates: InteractionCoordinates)
        throws
        -> ElementSimpleGestures
}
