import SBTUITestTunnel
import MixboxTestsFoundation
import MixboxBlack
import MixboxUiTestsFoundation
import MixboxIpcSbtuiClient
import MixboxIpc
import MixboxDi
import TestsIpc

final class WhiteBoxTestCaseDependencies: DependencyCollectionRegisterer {
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            MixboxTestsFoundationDependencies(
                stepLogger: Singletons.stepLogger,
                enableXctActivityLogging: true
            ),
            TestCaseDependencies()
        ]
    }
    
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
    }
}
