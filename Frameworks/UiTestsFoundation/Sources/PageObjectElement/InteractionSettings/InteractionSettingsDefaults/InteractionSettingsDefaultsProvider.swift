public protocol InteractionSettingsDefaultsProvider: AnyObject {
    func interactionSettingsDefaults(
        interaction: ElementInteraction)
        -> InteractionSettingsDefaults
}
