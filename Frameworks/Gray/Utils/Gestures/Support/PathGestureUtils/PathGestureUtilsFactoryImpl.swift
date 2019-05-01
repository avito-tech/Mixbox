public final class PathGestureUtilsFactoryImpl: PathGestureUtilsFactory {
    public init() {
        
    }
    
    public func pathGestureUtils() -> PathGestureUtils {
        return PathGestureUtilsImpl(
            // Refers to the minimum 10 points of scroll that is required for any scroll to be detected.
            scrollDetectionLength: 10,
            // In practice, this value seems to yield the best results by triggering
            // the gestures more accurately, even on slower machines:
            distanceBetweenTwoAdjacentPoints: 10,
            touchInjectionFrequency: TouchInjectorImpl.Constants.injectionFrequency // TODO: Remove this coupling
        )
    }
}
