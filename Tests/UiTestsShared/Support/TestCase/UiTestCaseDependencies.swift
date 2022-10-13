import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxUiKit
import MixboxDi
import TestsIpc

final class UiTestCaseDependencies: DependencyCollectionRegisterer {
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            TestCaseDependencies()
        ]
    }
    
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: StepLogger.self) { di in
            if Singletons.enableXctActivityLogging  {
                return XctActivityStepLogger(
                    originalStepLogger: Singletons.stepLogger,
                    xctAttachmentsAdder: try di.resolve()
                )
            } else {
                return Singletons.stepLogger
            }
        }
        di.register(type: ImagesProvider.self) { _ in
            RedImagesProvider()
        }
        di.register(type: FileSystem.self) { di in
            FileSystemImpl(
                fileManager: FileManager(),
                temporaryDirectoryPathProvider: try di.resolve()
            )
        }
        di.register(type: TemporaryDirectoryPathProvider.self) { _ in
            NsTemporaryDirectoryPathProvider()
        }
        di.register(type: PageObjects.self) { di in
            try PageObjects(
                apps: di.resolve()
            )
        }
    }
}
