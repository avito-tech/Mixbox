public protocol AlmightyElementActions {
    func tap(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    func press(
        duration: Double,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    func setText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    func swipe(
        direction: SwipeDirection,
        actionSettings: ActionSettings)
    
    func with(settings: ElementSettings) -> AlmightyElementActions
    
    // TODO: Remove/rewrite/repurpose (See issue #2)
    func typeText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    // TODO: Remove/rewrite/repurpose (See issue #2)
    func pasteText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    // TODO: Remove/rewrite/repurpose (See issue #2)
    func cutText(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    
    // TODO: Remove/rewrite/repurpose (See issue #2)
    func clearTextByTypingBackspaceMultipleTimes(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
}
