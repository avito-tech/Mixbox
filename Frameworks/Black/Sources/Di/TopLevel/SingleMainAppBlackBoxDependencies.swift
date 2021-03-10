import MixboxDi
import MixboxTestsFoundation
import MixboxUiTestsFoundation

// Example:

// You develop 1 main app, but also want to use third party apps,
// whether it is Apple's apps (Springboard.app, Settings.app) or a fake app that
// mimics some third-party app.
//
// Example of a fake app:
// 
// You want to test integration with some
// banking app. You know that it can open your app via a deep link.
// You make really tiny app that can only call `UIApplication.openUrl`
// after pressing some fake buttons. This app can do anything really, it's your choice.
//
// If you don't use third-party apps, consider using `SingleAppBlackBoxDependencies`.
//
// Difference between `MultipleMainAppsBlackBoxDependencies`:
//
// - this class also registers IPC client, because "main app" here means that
//   only your main app has MixboxInAppServices with set up IPC.
//   Calling it "single ipc app" instead of "single main app" would be more correct,
//   albeit maybe less clear for a user of Mixbox.
//
// Difference between `SingleAppBlackBoxDependencies`:
//
// - this class lacks registration of dependencies for locating views,
//   because third-party apps have different bundle ids and locating such apps
//   require to create different stacks of dependencies per app.
//
public final class SingleMainAppBlackBoxDependencies: BaseTopLevelDependencyCollectionRegisterer {
    override public init() {
    }
    
    override public func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            MultipleMainAppsBlackBoxDependencies(),
            IpcClientsDependencyCollectionRegisterer()
        ]
    }
}
