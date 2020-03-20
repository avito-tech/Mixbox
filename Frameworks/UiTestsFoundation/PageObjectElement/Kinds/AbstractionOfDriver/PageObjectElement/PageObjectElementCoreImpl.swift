public final class PageObjectElementCoreImpl: PageObjectElementCore {
    public let settings: ElementSettings
    public let interactionPerformer: PageObjectElementInteractionPerformer
    
    public init(
        settings: ElementSettings,
        interactionPerformer: PageObjectElementInteractionPerformer)
    {
        self.settings = settings
        self.interactionPerformer = interactionPerformer
    }
    
    public func with(settings: ElementSettings) -> PageObjectElementCore {
        return PageObjectElementCoreImpl(
            settings: settings,
            interactionPerformer: interactionPerformer.with(settings: settings)
        )
    }
}
