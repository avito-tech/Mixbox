import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxUiKit
import MixboxDi
import MixboxBuiltinDi
import MixboxMocksRuntime
import MixboxGenerators
import MixboxStubbing
import TestsIpc

final class TestCaseDependencies: DependencyCollectionRegisterer {
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            MixboxStubbingDependencies()
        ]
    }
    
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        registerMocks(di: di)
        
        di.register(type: EnvironmentProvider.self) { _ in
            Singletons.environmentProvider
        }
        di.register(type: StepLogsProvider.self) { _ in
            Singletons.stepLogsProvider
        }
        di.register(type: StepLoggerRecordingStarter.self) { _ in
            Singletons.stepLoggerRecordingStarter
        }
        di.register(type: StepLogsCleaner.self) { _ in
            Singletons.stepLogsCleaner
        }
        di.register(type: FileLineForFailureProvider.self) { di in
            let identifierCharacterMask = "[a-zA-Z0-9_]"
            let identifier = "\(identifierCharacterMask)+?"
            let pathOfTwoOrMoreIdentifiers = "(\(identifier)\\.){2,}"
            
            return LastCallOfCurrentTestFileLineForFailureProvider(
                extendedStackTraceProvider: try di.resolve(),
                testSymbolPatterns: [
                    // Note: nested functions in test are ignored.
                    // Example: assert #1 (_: __C.CGRect, _: __C.CGRect, file: Swift.StaticString, line: Swift.UInt) -> () in UnitTests.CGRect_Rounding_Tests.test___mb_integralInside() -> ()
                    // Those functions are filtered my restricting regex to identifiers only
                    
                    // Example: TargetName.ClassName.test_withOptionalSuffix() -> ()
                    "^\(pathOfTwoOrMoreIdentifiers)test.*?\\(\\) -> \\(\\)",
                    
                    // Example: TargetName.ClassName.parameterized_test_withOptionalSuffix(message: Swift.String) -> ()
                    //          BlackBoxUiTests.SwipeActionTouchesTests.(parameterized_test___swipe___produces_expected_event in _54C65FCCFCCAFE9EE80FC2EC0649E42C)(swipeClosure: (MixboxUiTestsFoundation.ElementWithUi) -> (), startPoint: __C.CGPoint, endPointOffset: __C.CGVector) -> ()
                    "^\(pathOfTwoOrMoreIdentifiers)\\(?parameterized_test.*? -> \\(\\)",
                    
                    // Example: closure #2 () -> () in TargetName.ClassName.(parameterized_test in _FA5631F8141319A712430582B52492D9)(fooArg: Swift.String) -> ()
                    "\\(parameterized_test in",
                    "\\(test in"
                ]
            )
        }
        di.register(type: PerformanceLogger.self) { _ in
            Singletons.performanceLogger
        }
        di.register(type: TestFailureRecorder.self) { _ in
            XcTestFailureRecorder(
                currentTestCaseProvider: AutomaticCurrentTestCaseProvider(),
                shouldNeverContinueTestAfterFailure: false
            )
        }
    }
    
    private func registerMocks(di: DependencyRegisterer) {
        di.register(type: MockManagerFactory.self) { di in
            ConfiguredMockManagerFactory(
                testFailureRecorder: try di.resolve(),
                waiter: try di.resolve(),
                // TODO: Decrease to 3 or sync with InteractionSettingsDefaultsProviderImpl,
                // or maybe to add some new configurable entiry for storing default timeouts.
                defaultTimeout: 15,
                defaultPollingInterval: 0.1,
                dynamicCallableFactory: try di.resolve()
            )
        }
        di.register(type: MockRegisterer.self) { di in
            MockRegistererImpl(
                mockManagerFactory: try di.resolve()
            )
        }
        di.register(type: AnyGeneratorDynamicCallableBehavior.self) { _ in
            CompletionHandlerCallingAnyGeneratorDynamicCallableBehavior()
        }
        di.register(type: DynamicCallableFactory.self) { di in
            AnyGeneratorDynamicCallableFactory(
                anyGenerator: try di.resolve(),
                anyGeneratorDynamicCallableBehavior: try di.resolve()
            )
        }
    }
}
