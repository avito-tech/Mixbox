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
