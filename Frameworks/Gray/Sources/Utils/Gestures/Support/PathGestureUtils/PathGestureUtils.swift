// From https://github.com/google/EarlGrey/blob/91c27bb8a15e723df974f620f7f576a30a6a7484/EarlGrey/Action/GREYPathGestureUtils.m#L1

public enum TouchPathLengths {
    case optimizedForDuration(TimeInterval)
    case fixedMagnitudes
}

public protocol PathGestureUtils: AnyObject {
    func touchPath(
        startPoint: CGPoint,
        endPoint: CGPoint,
        touchPathLengths: TouchPathLengths,
        cancelInertia: Bool,
        skipUndetectableScroll: Bool)
        -> [CGPoint]
}
