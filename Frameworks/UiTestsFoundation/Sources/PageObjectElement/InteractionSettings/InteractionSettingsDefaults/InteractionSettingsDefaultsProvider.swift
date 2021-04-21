public protocol InteractionSettingsDefaultsProvider: class {
    func interactionSettingsDefaults(
        interaction: ElementInteraction)
        -> InteractionSettingsDefaults
}
