// Points are in coordinate space of window.
public final class DraggingInstruction: Codable, Equatable {
    // Point of initial touch
    public let initialTouchPoint: CGPoint
    
    // Point of the final touch. It is guaranteed that point is inside the screen.
    // So it is a "clipped" version of targetTouchPointExceedingScreenBounds.
    public let targetTouchPoint: CGPoint
    
    // initialTouchPoint + distance to scroll.
    // It can be used for optimizing scrolling. For example, if distance is big,
    // you can use faster scrolling, if it is small, you can use slower, but more precise solution.
    public let targetTouchPointExceedingScreenBounds: CGPoint
    
    // Hint that element might be visible. You can perform expensive visibility check if it is true.
    // You can skip expensive check if it is false.
    public let elementIntersectsWithScreen: Bool
    
    // Identifier of the target element. Can be used for visibility check.
    public let elementUniqueIdentifier: String?
    
    public init(
        initialTouchPoint: CGPoint,
        targetTouchPoint: CGPoint,
        targetTouchPointExceedingScreenBounds: CGPoint,
        elementIntersectsWithScreen: Bool,
        elementUniqueIdentifier: String?)
    {
        self.initialTouchPoint = initialTouchPoint
        self.targetTouchPoint = targetTouchPoint
        self.targetTouchPointExceedingScreenBounds = targetTouchPointExceedingScreenBounds
        self.elementIntersectsWithScreen = elementIntersectsWithScreen
        self.elementUniqueIdentifier = elementUniqueIdentifier
    }
    
    public static func ==(left: DraggingInstruction, right: DraggingInstruction) -> Bool {
        return left.initialTouchPoint == right.initialTouchPoint
            && left.targetTouchPoint == right.targetTouchPoint
            && left.targetTouchPointExceedingScreenBounds == right.targetTouchPointExceedingScreenBounds
            && left.elementIntersectsWithScreen == right.elementIntersectsWithScreen
            && left.elementUniqueIdentifier == right.elementUniqueIdentifier
    }
}
