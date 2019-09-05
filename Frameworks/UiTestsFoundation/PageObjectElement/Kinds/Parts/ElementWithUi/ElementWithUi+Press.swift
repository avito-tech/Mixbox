import MixboxFoundation

extension ElementWithUi {
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
            interactionCoordinates: InteractionCoordinates(
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
}
