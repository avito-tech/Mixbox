// From https://github.com/google/EarlGrey/blob/91c27bb8a15e723df974f620f7f576a30a6a7484/EarlGrey/Action/GREYPathGestureUtils.m#L1

public protocol PathGestureUtils {
    /**
     *  Touch path between the given points with the option to cancel the inertia.
     *
     *  @param startPoint    The start point of the touch path.
     *  @param endPoint      The end point of the touch path.
     *  @param duration      How long the gesture should last.
     *                       Can be NAN to indicate that path lengths of fixed magnitude should be used.
     *  @param cancelInertia A check to nullify the inertia in the touch path.
     *
     *  @return A touch path between the two points.
     */
    func touchPath(
        startPoint: CGPoint,
        endPoint: CGPoint,
        duration: TimeInterval,
        shouldCancelInertia cancelInertia: Bool)
        -> [CGPoint]
}
