import MixboxTestsFoundation
import MixboxGray
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxDi
import UiTestsSharedCode

final class GrayBoxTestCaseDependencies: DependencyCollectionRegisterer {
    private let bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider
    
    init(bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider) {
        self.bundleResourcePathProviderForTestsTarget = bundleResourcePathProviderForTestsTarget
    }
    
    private func nestedRegisteres() -> [DependencyCollectionRegisterer] {
        return [
            MixboxGrayDependencies(),
            UiTestCaseDependencies()
        ]
    }
    
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisteres().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: BundleResourcePathProvider.self) { [bundleResourcePathProviderForTestsTarget] _ in
            bundleResourcePathProviderForTestsTarget
        }
    }
}
