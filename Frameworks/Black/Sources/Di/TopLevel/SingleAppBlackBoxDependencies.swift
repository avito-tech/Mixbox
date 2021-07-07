import MixboxDi
import MixboxTestsFoundation
import MixboxUiTestsFoundation

// Example:

// You develop only 1 app and you do not need to use any other apps,
// like system apps or some fake apps that you write (mocking other third party
// apps that your main app interact with, like banking apps, maps, etc).
//
// Unlike `SingleMainAppBlackBoxDependencies` it contains all neccessary dependencies
// for locating views in your single `XCUIApplication`. This can be handy.
//
// If you want to use third party apps, you should manage different stacks of dependencies
// per different app. In that case `SingleMainAppBlackBoxDependencies` may be helpful.
//
public final class SingleAppBlackBoxDependencies: BaseTopLevelDependencyCollectionRegisterer {
    override public init() {
    }
    
    override public func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            SingleMainAppBlackBoxDependencies(),
            BlackBoxApplicationDependentDependencyCollectionRegisterer()
        ]
    }
    
    override public  func registerAdditionalDependencies(di: DependencyRegisterer) {
        di.register(type: ApplicationProvider.self) { _ in
            ApplicationProviderImpl { XCUIApplication() }
        }
    }
}
