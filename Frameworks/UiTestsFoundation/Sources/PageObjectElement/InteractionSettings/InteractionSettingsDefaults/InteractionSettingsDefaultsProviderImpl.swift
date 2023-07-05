import Foundation

public final class InteractionSettingsDefaultsProviderImpl: InteractionSettingsDefaultsProvider {
    public enum Preset {
        case blackBox
        case grayBox
        
        // `blackBox` preset is like `grayBox`, but less optimized and more safe for general case.
        public static var universal: Preset {
            Preset.blackBox
        }
    }
    
    private let preset: Preset
    
    public init(preset: Preset) {
        self.preset = preset
    }
    
    public func interactionSettingsDefaults(
        interaction: ElementInteraction)
        -> InteractionSettingsDefaults
    {
        return InteractionSettingsDefaults(
            scrollMode: .default,
            interactionTimeout: interactionTimeout(interaction: interaction),
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
    
    private func interactionTimeout(interaction: ElementInteraction) -> TimeInterval {
        // E2E are less responsive than tests without network. Network can add lags.
        //
        // `IsNotDisplayedCheck` is the only check that takes constant amount of time (equal to timeout)
        // due to a negation of `IsDisplayedAndMatchesCheck` inside. And this is either logical and practical,
        // for example, if we used 0 timeout test would have false positive result (in case if element is not immediately
        // visible, but appears after few milliseconds or even seconds, e.g. when screen is rendered from data from server).
        //
        // But in practice there is no reason to use very high timeouts for `IsNotDisplayedCheck`
        //
        // There should be a balance between speed of tests and stability. High timeouts slow down tests,
        // but low timeouts increase instability.
        
        switch preset {
        case .blackBox:
            return interaction is IsNotDisplayedCheck ? 5 : 30
        case .grayBox:
            return interaction is IsNotDisplayedCheck ? 3 : 15
        }
    }
}
