public final class ElementSettingsDefaultsProviderImpl: ElementSettingsDefaultsProvider {
    public init() {
    }
    
    public func elementSettingsDefaults() -> ElementSettingsDefaults {
        return ElementSettingsDefaults(
            scrollMode: .default,
            interactionTimeout: 15,
            interactionMode: .default,
            // A lot of root views are overlapped with navbar/status bar/tabbar.
            //
            // The default value of 1.0 will make checks for those views fail, and it is expected
            // to have about one such view for page object in real application.
            //
            // The value should ideally be greater than 0.5, because value greater than 0.5
            // indicates that the center is visible (it is true for pure vertical and pure horizontal layouts
            // and rectangle shapes of views). And the center is a default point for most gestures.
            percentageOfVisibleArea: 0.6
        )
    }
}
