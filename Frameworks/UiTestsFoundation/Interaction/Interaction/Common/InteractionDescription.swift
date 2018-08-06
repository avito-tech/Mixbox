public final class InteractionDescription {
    public let type: InteractionType
    public let settings: ResolvedInteractionSettings
    
    public init(
        type: InteractionType,
        settings: ResolvedInteractionSettings)
    {
        self.type = type
        self.settings = settings
    }
}
