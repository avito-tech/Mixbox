import MixboxDi
import MixboxUiTestsFoundation

public class BaseBlackBoxDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        di.register(type: DeviceScreenshotTaker.self) { _ in
            XcuiDeviceScreenshotTaker()
        }
        di.register(type: InteractionSettingsDefaultsProvider.self) { _ in
            InteractionSettingsDefaultsProviderImpl(preset: .blackBox)
        }
    }
}
