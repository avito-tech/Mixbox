import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxIpcCommon
import MixboxGray
import MixboxFoundation
import MixboxDi
import TestsIpc

final class GrayBoxTestCaseDependencies: DependencyCollectionRegisterer {
    private let bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider
    
    init(bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider) {
        self.bundleResourcePathProviderForTestsTarget = bundleResourcePathProviderForTestsTarget
    }
    
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            MixboxGrayDependencies(),
            UiTestCaseDependencies()
        ]
    }
    
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: IpcRouterHolder.self) { _ in
            IpcRouterHolder()
        }
        di.register(type: IpcRouterProvider.self) { di in
            try di.resolve() as IpcRouterHolder
        }
        di.register(type: Apps.self) { di in
            let mainUiKitHierarchy: PageObjectDependenciesFactory = try di.resolve()
            return Apps(
                mainUiKitHierarchy: mainUiKitHierarchy,
                mainXcuiHierarchy: mainUiKitHierarchy, // TODO: This is wrong! Add Fake object that produces errors for function calls.
                mainDefaultHierarchy: mainUiKitHierarchy,
                settings: mainUiKitHierarchy, // TODO: This is wrong!
                springboard: mainUiKitHierarchy // TODO: This is wrong!
            )
        }
        di.register(type: BundleResourcePathProvider.self) { [bundleResourcePathProviderForTestsTarget] _ in
            bundleResourcePathProviderForTestsTarget
        }
    }
}
