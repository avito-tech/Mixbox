import XCTest
import MixboxTestsFoundation
import MixboxFoundation

final class ExtendedStackTraceProviderImplTests: XCTestCase {
    private func currentFileLine(file: StaticString = #file, line: UInt = #line) -> HeapFileLine {
        return HeapFileLine(
            file: "\(file)",
            line: UInt64(line)
        )
    }
    
    private var provider = ExtendedStackTraceProviderImpl(
        stackTraceProvider: StackTraceProviderImpl(),
        extendedStackTraceEntryFromCallStackSymbolsConverter: ExtendedStackTraceEntryFromStackTraceEntryConverterImpl()
    )
    
    // TODO: Option to remove stacktrace of functions that generate stacktrace?
    func disabled_test_returns_same_count_of_entries_as_thread() {
        XCTAssertEqual(Thread.callStackReturnAddresses.count, provider.extendedStackTrace().count)
        XCTAssertEqual(Thread.callStackSymbols.count, provider.extendedStackTrace().count)
    }
    
    func test_on_real_trace() {
        var traceOrNil: [ExtendedStackTraceEntry]?
        let specialFile = FileForStacktraceTestsWithFixedNameAndLineNumbers {
            traceOrNil = self.provider.extendedStackTrace()
        }
        specialFile.func_line2()
        
        guard let trace = traceOrNil, trace.count > 5 else {
            XCTFail("Did not receive trace from extendedStackTrace()")
            return
        }
        
        XCTAssertEqual(trace[5].file?.mb_lastPathComponent, "FileForStacktraceTestsWithFixedNameAndLineNumbers.swift")
        XCTAssertEqual(trace[5].line, 10)
        XCTAssertEqual(trace[5].owner, "UnitTests")
        
        let expectedSymbol: String
        switch XcodeVersion.xcodeVersion {
        case .v10orHigher:
            expectedSymbol = "$S9UnitTests017FileForStacktraceB27WithFixedNameAndLineNumbersC11func_line10yyF"
        case .v9orLower:
            expectedSymbol = "_T09UnitTests017FileForStacktraceB27WithFixedNameAndLineNumbersC11func_line10yyF"
        }
        
        XCTAssert(
            trace[5].symbol == expectedSymbol,
            "Expected symbol: \(expectedSymbol), actual: \(String(describing: trace[5].symbol))"
        )
        
        XCTAssertEqual(trace[5].demangledSymbol, "UnitTests.FileForStacktraceTestsWithFixedNameAndLineNumbers.func_line10() -> ()")
    }
}
