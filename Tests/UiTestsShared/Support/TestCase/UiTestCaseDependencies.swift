import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxUiKit
import MixboxDi

final class UiTestCaseDependencies: DependencyCollectionRegisterer {
    func register(dependencyRegisterer di: DependencyRegisterer) {
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
        di.register(type: FileLineForFailureProvider.self) { di in
            LastCallOfCurrentTestFileLineForFailureProvider(
                extendedStackTraceProvider: try di.resolve(),
                testSymbolPatterns: [
                    // Example: TargetName.ClassName.test_withOptionalSuffix() -> ()
                    ".+?\\..+?\\.test.*?\\(\\) -> \\(\\)",
                    
                    // Example: TargetName.ClassName.parametrizedTest_withOptionalSuffix(message: Swift.String) -> ()
                    //          BlackBoxUiTests.SwipeActionTouchesTests.(parametrizedTest___swipe___produces_expected_event in _54C65FCCFCCAFE9EE80FC2EC0649E42C)(swipeClosure: (MixboxUiTestsFoundation.ElementWithUi) -> (), startPoint: __C.CGPoint, endPointOffset: __C.CGVector) -> ()
                    ".+?\\..+?\\.\\(?parametrizedTest.*? -> \\(\\)",
                    
                    // Example: closure #2 () -> () in TargetName.ClassName.(parametrizedTest in _FA5631F8141319A712430582B52492D9)(fooArg: Swift.String) -> ()
                    "\\(parametrizedTest in",
                    "\\(test in"
                ]
            )
        }
        di.register(type: PageObjects.self) { di in
            PageObjects(
                apps: try di.resolve()
            )
        }
        di.register(type: SignpostActivityLogger.self) { _ in
            if #available(iOS 12.0, *) {
                return SignpostActivityLoggerImpl(
                    signpostLoggerFactory: SignpostLoggerFactoryImpl(),
                    subsystem: "mixbox",
                    category: "mixbox" // TODO: Find a use for it
                )
            } else {
                return DisabledSignpostActivityLogger()
            }
        }
    }
}
