import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxUiKit
import MixboxDi

// Example of shared dependencies.
public final class UiTestCaseDependencies: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        // Register your collection of page objects here and resolve it from tests.
        di.register(type: PageObjects.self) { di in
            PageObjects(
                pageObjectDependenciesFactory: try di.resolve()
            )
        }
        
        // This utility can be configured to highlight test failures in your tests.
        // For example, if you call XCTFail in your library then you will not see test failure
        // in the file of your test. But with `XcTestFailureRecorder` that uses `FileLineForFailureProvider`
        // you can improve highlighting of errors. It will dump and symbolicate stacktrace and find
        // file and line where test failure occured, according to regular expressions defining where
        // a failure should be highlighted.
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
                    
                    // Example: TargetName.ClassName.parametrizedTest_withOptionalSuffix(message: Swift.String) -> ()
                    //          BlackBoxUiTests.SwipeActionTouchesTests.(parametrizedTest___swipe___produces_expected_event in _54C65FCCFCCAFE9EE80FC2EC0649E42C)(swipeClosure: (MixboxUiTestsFoundation.ElementWithUi) -> (), startPoint: __C.CGPoint, endPointOffset: __C.CGVector) -> ()
                    "^\(pathOfTwoOrMoreIdentifiers)\\(?parametrizedTest.*? -> \\(\\)",
                    
                    // Example: closure #2 () -> () in TargetName.ClassName.(parametrizedTest in _FA5631F8141319A712430582B52492D9)(fooArg: Swift.String) -> ()
                    "\\(parametrizedTest in",
                    "\\(test in"
                ]
            )
        }
    }
}
