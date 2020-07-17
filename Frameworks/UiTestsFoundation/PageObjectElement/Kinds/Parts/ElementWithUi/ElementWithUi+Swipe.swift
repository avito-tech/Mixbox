import MixboxFoundation
import MixboxIpcCommon

extension ElementWithUi {
    @discardableResult
    public func swipe(
        startPoint: SwipeActionStartPoint = .default,
        endPoint: SwipeActionEndPoint,
        speed: TouchActionSpeed? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = SwipeAction(
            startPoint: startPoint,
            endPoint: endPoint,
            speed: speed
        )
        
        return core.perform(
            action: action,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipe(
        direction: SwipeDirection,
        startPoint: SwipeActionStartPoint = .default,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let swipeActionEndPoint: SwipeActionEndPoint
        
        if let length = length {
            swipeActionEndPoint = .directionWithLength(direction, length)
        } else {
            swipeActionEndPoint = .directionWithDefaultLength(direction)
        }
        
        return swipe(
            startPoint: startPoint,
            endPoint: swipeActionEndPoint,
            speed: speed,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeUp(
        startPoint: SwipeActionStartPoint = .default,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return swipe(
            direction: .up,
            startPoint: startPoint,
            length: length,
            speed: speed,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeDown(
        startPoint: SwipeActionStartPoint = .default,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return swipe(
            direction: .down,
            startPoint: startPoint,
            length: length,
            speed: speed,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeLeft(
        startPoint: SwipeActionStartPoint = .default,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return swipe(
            direction: .left,
            startPoint: startPoint,
            length: length,
            speed: speed,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeRight(
        startPoint: SwipeActionStartPoint = .default,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return swipe(
            direction: .right,
            startPoint: startPoint,
            length: length,
            speed: speed,
            failTest: failTest,
            file: file,
            line: line
        )
    }
}
