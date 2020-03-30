import XCTest
import MixboxTestsFoundation

// TODO: Remove class and test?
// Tests are disabled. Symbolication using XCTest stopped working probably since Catalina.
final class FirstOfTargetFileFromCallStackFileLineForFailureProviderTests: XCTestCase {
    private func currentFileLine(file: StaticString = #file, line: UInt = #line) -> HeapFileLine {
        return HeapFileLine(
            file: "\(file)",
            line: UInt64(line)
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
    
    private func nested() -> (HeapFileLine?, HeapFileLine) {
        return (provider.fileLineForFailure(), currentFileLine())
    }
    
    func disabled_test_double_nested() {
        let (actual, expected) = double_nested()
        XCTAssertEqual(actual, expected)
    }
    
    private func double_nested() -> (HeapFileLine?, HeapFileLine) {
        return nested()
    }
    
    func disabled_test_other_file() {
        var actualFileLine: HeapFileLine?
        var expectedFileLine: HeapFileLine?
        let otherFile = FileForStacktraceTestsWithFixedNameAndLineNumbers {
            // Other file will be ignored
            actualFileLine = self.provider.fileLineForFailure(); expectedFileLine = self.currentFileLine()
        }
        
        otherFile.func_line2()
        
        XCTAssertNotNil(expectedFileLine)
        XCTAssertEqual(actualFileLine, expectedFileLine)
    }
}
