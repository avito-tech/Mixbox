import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxArtifacts
import MixboxReporting
import MixboxIpc
import MixboxFoundation
@testable import TestedApp

class TestCase: XCTestCase, FailureGatherer {
    private(set) lazy var testCaseUtils: TestCaseUtils = self.reuseState { TestCaseUtils() }
    
    var permissions: ApplicationPermissionsSetter {
        return testCaseUtils.permissions
    }
    
    var pageObjects: PageObjects {
        return testCaseUtils.pageObjects
    }
    
    func precondition() {
    }
    
    override func setUp() {
        super.setUp()
        
        // Fail faster on CI
        let isCiBuild = ProcessInfo.processInfo.environment["MIXBOX_CI_IS_CI_BUILD"] == "true"
        continueAfterFailure = !isCiBuild
        
        reuseState {
            precondition()
        }
    }
    
    func openScreen(name: String) {
        let viewController = TestingViewController(
            testingViewControllerSettings: TestingViewControllerSettings(
                name: name
            )
        )
        
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    // MARK: - Gathering failures
    
    private enum RecordFailureMode {
        case failTest
        case gatherFailures
    }
    
    private var recordFailureMode = RecordFailureMode.failTest
    private var gatheredFailures = [XcTestFailure]()
    func gatherFailures(_ body: () -> ()) -> [XcTestFailure] {
        let saved_recordFailureMode = recordFailureMode
        let saved_gatheredFailures = gatheredFailures
        
        recordFailureMode = .gatherFailures
        gatheredFailures = []
        
        body()
        
        let valueToReturn = gatheredFailures
        
        gatheredFailures = saved_gatheredFailures + gatheredFailures
        recordFailureMode = saved_recordFailureMode
        
        return valueToReturn
    }
    
    override func recordFailure(
        withDescription description: String,
        inFile filePath: String,
        atLine lineNumber: Int,
        expected: Bool)
    {
        let fileLine = testCaseUtils.fileLineForFailureProvider.fileLineForFailure()
            ?? HeapFileLine(file: filePath, line: UInt64(lineNumber))
        
        let failure = XcTestFailure(
            description: description,
            file: fileLine.file,
            line: Int(fileLine.line),
            expected: expected
        )
        
        switch recordFailureMode {
        case .failTest:
            // Note that you can set a breakpoint here (it is very convenient):
            super.recordFailure(
                withDescription: failure.description,
                inFile: failure.file,
                atLine: failure.line,
                expected: failure.expected
            )
        case .gatherFailures:
            gatheredFailures.append(failure)
        }
    }
    
    // MARK: - Reusing state
    
    var reuseState: Bool {
        return true
    }
    
    private func reuseState<T>(file: StaticString = #file, line: UInt = #line, block: () -> (T)) -> T {
        // TODO: Make it work!
        let itWorksAsExpectedEvenOnCi = false
        
        if itWorksAsExpectedEvenOnCi && reuseState {
            let fileLine = FileLine(file: file, line: line)
            return TestStateRecycling.instance.reuseState(testCase: type(of: self), fileLine: fileLine) {
                block()
            }
        } else  {
            return block()
        }
    }
    
}
