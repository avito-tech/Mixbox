import MixboxFoundation

extension ElementWithUi {
    @discardableResult
    public func tap(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = TapAction(
            interactionCoordinates: InteractionCoordinatesImpl(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            ),
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
    public func press(
        duration: Double = 0.5,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = PressAction(
            duration: duration,
            interactionCoordinates: InteractionCoordinatesImpl(
                normalizedCoordinate: normalizedCoordinate,
                absoluteOffset: absoluteOffset
            ),
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
    public func swipeToDirection(
        _ direction: SwipeDirection,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
        failTest: Bool = true,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        let action = SwipeAction(
            direction: direction,
            // TODO: Implement?
            interactionCoordinates: InteractionCoordinatesImpl(
                normalizedCoordinate: nil,
                absoluteOffset: nil
            ),
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
    public func swipeUp(
        failTest: Bool = true,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return swipeToDirection(
            .up,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeDown(
        failTest: Bool = true,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return swipeToDirection(
            .down,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeLeft(
        failTest: Bool = true,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return swipeToDirection(
            .left,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
    
    @discardableResult
    public func swipeRight(
        failTest: Bool = true,
        minimalPercentageOfVisibleArea: CGFloat = ActionsKludges.minimalPercentageOfVisibleAreaOfElementThatIsProbablyEnoughToTapOnIt,
        file: StaticString = #file,
        line: UInt = #line)
        -> Bool
    {
        return swipeToDirection(
            .right,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            failTest: failTest,
            file: file,
            line: line
        )
    }
}
