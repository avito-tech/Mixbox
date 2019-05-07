import MixboxUiKit

public final class PathGestureUtilsImpl: PathGestureUtils {
    private let scrollDetectionLength: CGFloat
    
    // The minimum distance between any 2 adjacent points in the touch path.
    private let minimalDistanceBetweenTwoAdjacentPoints: CGFloat
    
    // Higher frequency - more events. Should be synchronized with TouchInjector.
    // TODO: Synchronize automatically via better interfaces.
    private let touchInjectionFrequency: TimeInterval
    
    public init(
        scrollDetectionLength: CGFloat,
        minimalDistanceBetweenTwoAdjacentPoints: CGFloat,
        touchInjectionFrequency: TimeInterval)
    {
        self.scrollDetectionLength = scrollDetectionLength
        self.minimalDistanceBetweenTwoAdjacentPoints = minimalDistanceBetweenTwoAdjacentPoints
        self.touchInjectionFrequency = touchInjectionFrequency
    }
    
    public func touchPath(
        startPoint: CGPoint,
        endPoint: CGPoint,
        duration: TimeInterval,
        shouldCancelInertia cancelInertia: Bool)
        -> [CGPoint]
    {
        let duration = CGFloat(duration)
        let deltaVector = CGVector.mb_init(start: startPoint, end: endPoint)
        let pathLength = deltaVector.mb_length()
        
        if pathLength <= scrollDetectionLength {
            return [] // TODO: This may be unexpected! Express this logic via interface.
        }
        
        var touchPath: [CGPoint] = []
        if duration.isNaN {
            // After the start point, rest of the path is divided into equal segments and a touch point is
            // created for each segment.
            let totalPoints = Int(pathLength / minimalDistanceBetweenTwoAdjacentPoints)
            // Compute delta for each point and create a path with it.
            let deltaX = (endPoint.x - startPoint.x) / CGFloat(totalPoints)
            let deltaY = (endPoint.y - startPoint.y) / CGFloat(totalPoints)
            for i in 0..<totalPoints {
                let touchPoint = CGPoint(
                    x: startPoint.x + (deltaX * CGFloat(i)),
                    y: startPoint.y + (deltaY * CGFloat(i))
                )
                touchPath.append(touchPoint)
            }
        } else {
            touchPath.append(startPoint)
            
            // Uses the kinematics equation for distance: d = a*t*t/2 + v*t
            let initialVelocity: CGFloat = 0
            let initialDisplacement: CGFloat = initialVelocity * duration
            let acceleration: CGFloat = (2 * (pathLength - initialDisplacement)) / (duration * duration)
            
            // Determine the angle which will be used for calculating individual x and y components of the
            // displacement.
            var angleFromXAxis: CGFloat = 0.0
            var deltaPoint = CGPoint(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y)
            if deltaPoint.x == 0 {
                let pi2 = CGFloat.pi / 2
                angleFromXAxis = deltaPoint.y > 0 ? pi2 : -pi2
            } else if deltaPoint.y == 0 {
                angleFromXAxis = deltaPoint.x > 0 ? 0 : -.pi
            } else {
                angleFromXAxis = atan2(deltaPoint.y, deltaPoint.x)
            }
            
            let cosAngle = cos(angleFromXAxis)
            let sinAngle = sin(angleFromXAxis)
            
            // Duration is divided into fixed intervals which depends on the frequency at which touches are
            // delivered. The first and last interval are always going to be the start and end touch points.
            // Through experiments, it was discovered that not all gestures trigger until there is a
            // minimum of `minimalDistanceBetweenTwoAdjacentPoints` movement. For that reason, we find the
            // interval (after first touch point) at which displacement is at least
            // `minimalDistanceBetweenTwoAdjacentPoints` and continue the gesture from there.
            // With this approach, touch points after first touch point is at least
            // `minimalDistanceBetweenTwoAdjacentPoints` apart and gesture recognizers can detect them
            // correctly.
            let interval = 1 / CGFloat(touchInjectionFrequency)
            // The last interval is always the last touch point so use 2nd to last as the end of loop below.
            let interval_penultimate: CGFloat = duration - interval
            var interval_shift: CGFloat = sqrt(((2 * (minimalDistanceBetweenTwoAdjacentPoints - initialDisplacement)) / acceleration))
            // Negative interval can't be shifted.
            if interval_shift < 0 {
                interval_shift = 0
            }
            // Boundary-align interval_shift to interval.
            interval_shift = ceil(interval_shift / interval) * interval
            // interval_shift past 2nd last interval means only 2 touches will be injected.
            // Adjust it to the last interval.
            if interval_shift > interval_penultimate {
                interval_shift = interval_penultimate
            }
            
            var time = interval_shift
            while time < interval_penultimate {
                var displacement: CGFloat = (acceleration * time * time) / 2
                displacement = displacement + (initialVelocity * time)
                
                var deltaX: CGFloat = displacement * cosAngle
                var deltaY: CGFloat = displacement * sinAngle
                var touchPoint = CGPoint(x: CGFloat(startPoint.x + deltaX), y: CGFloat(startPoint.y + deltaY))
                touchPath.append(touchPoint)
                time += interval
            }
        }
        
        if cancelInertia, let secondLastPoint = touchPath.last {
            // To cancel inertia, slow down as approaching the end point. This is done by inserting a series
            // of points between the 2nd last and the last point.
            let numSlowTouchesBetweenSecondLastAndLastTouch = 20
            
            var secondLastToLastVector: CGVector = CGVector.mb_init(
                start: secondLastPoint,
                end: endPoint
            )
            
            var slowTouchesVectorScale = 1.0 / CGFloat(numSlowTouchesBetweenSecondLastAndLastTouch)
            var slowTouchesVector: CGVector = secondLastToLastVector.mb_scaled(scale: slowTouchesVectorScale)
            
            var slowTouchPoint = secondLastPoint
            for i in 0..<(numSlowTouchesBetweenSecondLastAndLastTouch - 1) {
                slowTouchPoint = slowTouchPoint + slowTouchesVector
                touchPath.append(slowTouchPoint)
            }
        }
        
        touchPath.append(endPoint)
        
        return touchPath
    }
}
