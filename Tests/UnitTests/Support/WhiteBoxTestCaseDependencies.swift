import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxDi

final class WhiteBoxTestCaseDependencies: DependencyCollectionRegisterer {
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            ApplicationIndependentTestsDependencyCollectionRegisterer(),
            TestCaseDependencies()
        ]
    }
    
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
    }
}
