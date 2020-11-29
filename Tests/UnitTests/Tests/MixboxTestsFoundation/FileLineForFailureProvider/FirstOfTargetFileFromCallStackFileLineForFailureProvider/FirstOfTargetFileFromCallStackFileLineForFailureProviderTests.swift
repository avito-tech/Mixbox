import XCTest
import MixboxFoundation
import MixboxTestsFoundation

// TODO: Remove class and test?
// Tests are disabled. Symbolication using XCTest stopped working probably since Catalina.
final class FirstOfTargetFileFromCallStackFileLineForFailureProviderTests: XCTestCase {
    private func currentFileLine(file: StaticString = #file, line: UInt = #line) -> RuntimeFileLine {
        return RuntimeFileLine(
            file: "\(file)",
            line: line
        )
    }
    
    private var provider = FirstOfTargetFileFromCallStackFileLineForFailureProvider(
        extendedStackTraceProvider: ExtendedStackTraceProviderImpl(
            stackTraceProvider: StackTraceProviderImpl(),
            extendedStackTraceEntryFromCallStackSymbolsConverter: ExtendedStackTraceEntryFromStackTraceEntryConverterImpl()
        ),
        file: "\(#file)"
    )
    
    func disabled_test() {
        XCTAssertEqual(provider.fileLineForFailure(), currentFileLine())
    }
    
    func disabled_test_with_suffix() {
        XCTAssertEqual(provider.fileLineForFailure(), currentFileLine())
    }
    
    func disabled_test_nested() {
        let (actual, expected) = nested()
        XCTAssertEqual(actual, expected)
    }
    
    private func nested() -> (RuntimeFileLine?, RuntimeFileLine) {
        return (provider.fileLineForFailure(), currentFileLine())
    }
    
    func disabled_test_double_nested() {
        let (actual, expected) = double_nested()
        XCTAssertEqual(actual, expected)
    }
    
    private func double_nested() -> (RuntimeFileLine?, RuntimeFileLine) {
        return nested()
    }
    
    func disabled_test_other_file() {
        var actualFileLine: RuntimeFileLine?
        var expectedFileLine: RuntimeFileLine?
        let otherFile = FileForStacktraceTestsWithFixedNameAndLineNumbers {
            // Other file will be ignored
            actualFileLine = self.provider.fileLineForFailure(); expectedFileLine = self.currentFileLine()
        }
        
        otherFile.func_line2()
        
        XCTAssertNotNil(expectedFileLine)
        XCTAssertEqual(actualFileLine, expectedFileLine)
    }
}
