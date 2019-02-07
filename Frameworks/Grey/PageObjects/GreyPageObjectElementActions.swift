import MixboxUiTestsFoundation

// TODO:
//
// 1. Share most of the code with XcuiPageObjectElementActions.
// 2. Remove XcuiPageObjectElementActions and GreyPageObjectElementActions, use shared class.
// (like GreyPageObjectElemenChecks and GreyPageObjectElemenActions became AlmightyElementChecksImpl)
//
public final class GreyPageObjectElementActions: AlmightyElementActions {
    private let elementSettings: ElementSettings
    
    public init(
        elementSettings: ElementSettings)
    {
        self.elementSettings = elementSettings
    }
    
    public func tap(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        preconditionFailure("Not implemented")
    }
    
    public func press(
        duration: Double,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        preconditionFailure("Not implemented")
    }
    
    public func setText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        preconditionFailure("Not implemented")
    }
    
    public func swipe(
        direction: SwipeDirection,
        actionSettings: ActionSettings)
    {
        preconditionFailure("Not implemented")
    }
    
    public func with(settings: ElementSettings) -> AlmightyElementActions {
        preconditionFailure("Not implemented")
    }
    
    public func typeText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        preconditionFailure("Not implemented")
    }
    
    public func pasteText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        preconditionFailure("Not implemented")
    }
    
    public func cutText(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        preconditionFailure("Not implemented")
    }
    
    public func clearTextByTypingBackspaceMultipleTimes(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        preconditionFailure("Not implemented")
    }
}
