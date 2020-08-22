import MixboxDi
import MixboxUiTestsFoundation

public final class MixboxBlackDependencies: DependencyCollectionRegisterer {
    public init() {
    }
    
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            MixboxUiTestsFoundationDependencies()
        ]
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: ScreenshotTaker.self) { _ in
            XcuiScreenshotTaker()
        }
    }
}
