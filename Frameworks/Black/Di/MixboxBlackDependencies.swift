import MixboxDi
import MixboxUiTestsFoundation

public final class MixboxBlackDependencies: DependencyCollectionRegisterer {
    private let mixboxUiTestsFoundationDependencies: MixboxUiTestsFoundationDependencies
    
    public init(mixboxUiTestsFoundationDependencies: MixboxUiTestsFoundationDependencies) {
        self.mixboxUiTestsFoundationDependencies = mixboxUiTestsFoundationDependencies
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        mixboxUiTestsFoundationDependencies.register(dependencyRegisterer: di)
        
        di.register(type: ScreenshotTaker.self) { _ in
            XcuiScreenshotTaker()
        }
        di.register(type: ApplicationQuiescenceWaiter.self) { _ in
            XcuiApplicationQuiescenceWaiter()
        }
    }
}
