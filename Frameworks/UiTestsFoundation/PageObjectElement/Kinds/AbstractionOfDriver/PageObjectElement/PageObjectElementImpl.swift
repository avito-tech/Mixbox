public final class PageObjectElementImpl: PageObjectElement {
    public let settings: ElementSettings
    public let interactionPerformer: PageObjectElementInteractionPerformer
    
    public init(
        settings: ElementSettings,
        interactionPerformer: PageObjectElementInteractionPerformer)
    {
        self.settings = settings
        self.interactionPerformer = interactionPerformer
    }
    
    public func with(settings: ElementSettings) -> PageObjectElement {
        return PageObjectElementImpl(
            settings: settings,
            interactionPerformer: interactionPerformer.with(settings: settings)
        )
    }
}
