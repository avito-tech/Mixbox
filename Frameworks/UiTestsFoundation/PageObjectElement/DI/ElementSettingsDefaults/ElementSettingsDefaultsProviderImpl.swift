public final class ElementSettingsDefaultsProviderImpl: ElementSettingsDefaultsProvider {
    public init() {
    }
    
    public func elementSettingsDefaults() -> ElementSettingsDefaults {
        return ElementSettingsDefaults(
            scrollMode: .default,
            interactionTimeout: 15,
            interactionMode: .default,
            //
            // `percentageOfVisibleArea` specifies how much of the element should be visible, for example, for check to pass.
            //
            // A lot of root views are overlapped with navbar/status bar/tabbar (such views are about 90% visible).
            //
            // The default value of 1.0 will make checks for those views fail, and it is expected
            // to have about one such view for page object in real application.
            //
            // But when keyboard is open on smaller devices then only about 50% of view is visible. So 50% is a default
            // value. The idea behind the default value is to minimize amount of customization needed in tests, ideally
            // to zero, while maximizing this value to improve quality of tests (ability to find layout bugs for example).
            // In a pretty big project 50% works well.
            //
            // The value should ideally be greater than 0.5, because value greater than 0.5
            // indicates that the center is visible (it is true for pure vertical and pure horizontal layouts
            // and rectangle shapes of views). And the center is a default point for most gestures.
            //
            // But the problem with tapping should be solved with other measures, like detecting actually visible
            // pixels for tapping them instead of center of the element.
            //
            percentageOfVisibleArea: 0.5,
            pixelPerfectVisibilityCheck: false
        )
    }
}
