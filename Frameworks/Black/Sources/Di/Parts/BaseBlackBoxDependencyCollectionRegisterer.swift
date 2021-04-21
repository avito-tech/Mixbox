import MixboxDi
import MixboxUiTestsFoundation

public class BaseBlackBoxDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        di.register(type: ScreenshotTaker.self) { _ in
            XcuiScreenshotTaker()
        }
        di.register(type: InteractionSettingsDefaultsProvider.self) { _ in
            InteractionSettingsDefaultsProviderImpl(preset: .blackBox)
        }
    }
}
