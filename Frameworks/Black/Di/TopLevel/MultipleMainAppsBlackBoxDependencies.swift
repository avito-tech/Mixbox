import MixboxDi
import MixboxTestsFoundation
import MixboxUiTestsFoundation

// Example: You develop 2 apps that interact with each other.
// NOTE: This case is not really supported. We don't know if it will work,
// and this code was added just to make future development easier.
//
// Consider using `SingleMainAppBlackBoxDependencies` if you have 1 main app
// and different third party apps for example.
public final class MultipleMainAppsBlackBoxDependencies: BaseTopLevelDependencyCollectionRegisterer {
    override public init() {
    }
    
    override public func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            ApplicationIndependentTestsDependencyCollectionRegisterer(),
            ApplicationIndependentUiTestsDependencyCollectionRegisterer(),
            BlackBoxApplicationIndependentDependencyCollectionRegisterer()
        ]
    }
}
