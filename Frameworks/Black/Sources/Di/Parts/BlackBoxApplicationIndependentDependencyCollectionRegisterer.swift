import MixboxDi
import MixboxUiTestsFoundation

public final class BlackBoxApplicationIndependentDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        di.register(type: ScreenshotTaker.self) { _ in
            XcuiScreenshotTaker()
        }
    }
}
