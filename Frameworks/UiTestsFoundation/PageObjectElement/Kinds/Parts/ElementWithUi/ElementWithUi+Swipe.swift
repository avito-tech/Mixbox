import MixboxFoundation

extension ElementWithUi {
    @discardableResult
    public func swipe(
        startPoint: SwipeActionStartPoint = .center,
        endPoint: SwipeActionEndPoint,
        speed: TouchActionSpeed? = nil,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = SwipeAction(
            startPoint: startPoint,
            endPoint: endPoint,
            speed: speed,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
        
        return implementation.perform(
            action: action,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipe(
        direction: SwipeDirection,
        startPoint: InteractionCoordinates? = nil,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
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
        
        let swipeActionStartPoint: SwipeActionStartPoint
        
        if let startPoint = startPoint {
            swipeActionStartPoint = .interactionCoordinates(startPoint)
        } else {
            swipeActionStartPoint = .center
        }
        
        return swipe(
            startPoint: swipeActionStartPoint,
            endPoint: swipeActionEndPoint,
            speed: speed,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeUp(
        startPoint: InteractionCoordinates? = nil,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
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
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeDown(
        startPoint: InteractionCoordinates? = nil,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
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
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeLeft(
        startPoint: InteractionCoordinates? = nil,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
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
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeRight(
        startPoint: InteractionCoordinates? = nil,
        length: CGFloat? = nil,
        speed: TouchActionSpeed? = nil,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
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
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
}
