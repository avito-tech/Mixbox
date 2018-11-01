import XCTest
import MixboxTestsFoundation

final class ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests: XCTestCase {
    private let converter = ExtendedStackTraceEntryFromStackTraceEntryConverterImpl()
    
    func test() {
        let entry = converter.extendedStackTraceEntry(
            stackTraceEntry: StackTraceEntry(
                symbol: "0   ???                                 0x000000011b5041b2 0x0 + 4753211826",
                address: 0x000000011b5041b2
            )
        )
        
        check(
            entry: entry,
            file: nil,
            line: nil,
            owner: nil,
            symbol: nil,
            demangledSymbol: nil,
            address: 0x000000011b5041b2
        )
    }
    
    func test2() {
        let entry = converter.extendedStackTraceEntry(
            stackTraceEntry: StackTraceEntry(
                symbol: "2   xctest                              0x000000010e7a0069 main + 0",
                address: 0x000000010e7a0069
            )
        )
        
        check(
            entry: entry,
            file: nil,
            line: nil,
            owner: "xctest",
            symbol: "main",
            demangledSymbol: "main",
            address: 0x000000010e7a0069
        )
    }
    
    func test3() {
        // THIS TEST IS FLAKY (success rate ~99.5%)
        //
        // The test was run 4 times in the build, 4 failures
        //
        // ======= Failed test run #1 ==========
        // XCTAssertTrue failed - Expected file: nil, actual: Optional("*****/Frameworks/TestsFoundation/Reporting/FileLineForFailureProvider/StackTrace/ExtendedStackTraceEntryFromStackTraceEntryConverterImpl.swift")
        // UnitTests/FileLineForFailureProvider/ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests.swift:53
        // ======= Failed test run #2 ==========
        // XCTAssertTrue failed - Expected owner: Optional("XCTest"), actual: Optional("MixboxTestsFoundation")
        // UnitTests/FileLineForFailureProvider/ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests.swift:53
        // ======= Failed test run #3 ==========
        // XCTAssertTrue failed - Expected symbol: Optional("+[XCTestCase(Failures) performFailableBlock:shouldInterruptTest:]"), actual: Optional("_T0So19NSRegularExpressionC7OptionsVs10SetAlgebra10FoundationsAEP7isEmptySbvgTW")
        // UnitTests/FileLineForFailureProvider/ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests.swift:53
        // ======= Failed test run #4 ==========
        // XCTAssertTrue failed - Expected demangledSymbol: Optional("+[XCTestCase(Failures) performFailableBlock:shouldInterruptTest:]"), actual: Optional("protocol witness for Swift.SetAlgebra.isEmpty.getter : Swift.Bool in conformance __ObjC.NSRegularExpression.Options : Swift.SetAlgebra in Foundation")
        // UnitTests/FileLineForFailureProvider/ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests.swift:53
        
        let entry = converter.extendedStackTraceEntry(
            stackTraceEntry: StackTraceEntry(
                symbol: "7   XCTest                              0x000000010ed67ae3 +[XCTestCase(Failures) performFailableBlock:shouldInterruptTest:] + 36",
                address: 0x000000010ed67ae3
            )
        )
        
        check(
            entry: entry,
            file: nil,
            line: nil,
            owner: "XCTest",
            symbol: "+[XCTestCase(Failures) performFailableBlock:shouldInterruptTest:]",
            demangledSymbol: "+[XCTestCase(Failures) performFailableBlock:shouldInterruptTest:]",
            address: 0x000000010ed67ae3
        )
    }
    
    func test_onRealTestMethod() {
        let targetName = "UnitTests"
        let stackTrace = StackTraceProviderImpl().stackTrace(); let file = "\(#file)"; let line = UInt64(#line)
        
        guard let simpleEntry = stackTrace.first(where: { $0.symbol?.contains(targetName) == true }) else {
            XCTFail("Unable to perform test")
            return
        }
        
        let entry = converter.extendedStackTraceEntry(
            stackTraceEntry: simpleEntry
        )
        
        XCTAssertEqual(
            entry.file?.mb_lastPathComponent,
            "ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests.swift"
        )
        
        check(
            entry: entry,
            file: file,
            line: line,
            owner: "UnitTests",
            symbol: "_T09UnitTests027ExtendedStackTraceEntryFromdef13ConverterImplB0C21test_onRealTestMethodyyF",
            demangledSymbol: "UnitTests.ExtendedStackTraceEntryFromStackTraceEntryConverterImplTests.test_onRealTestMethod() -> ()",
            address: simpleEntry.address
        )
    }
    
    private func check(
        entry: ExtendedStackTraceEntry,
        file: String?,
        line: UInt64?,
        owner: String?,
        symbol: String?,
        demangledSymbol: String?,
        address expectedAddress: UInt64,
        fileWhereExecuted: StaticString = #file,
        lineWhereExecuted: UInt = #line)
    {
        XCTAssert(entry.file == file, "Expected file: \(file), actual: \(entry.file)", file: fileWhereExecuted, line: lineWhereExecuted)
        XCTAssert(entry.line == line, "Expected line: \(line), actual: \(entry.line)", file: fileWhereExecuted, line: lineWhereExecuted)
        XCTAssert(entry.owner == owner, "Expected owner: \(owner), actual: \(entry.owner)", file: fileWhereExecuted, line: lineWhereExecuted)
        XCTAssert(entry.symbol == symbol, "Expected symbol: \(symbol), actual: \(entry.symbol)", file: fileWhereExecuted, line: lineWhereExecuted)
        XCTAssert(entry.demangledSymbol == demangledSymbol, "Expected demangledSymbol: \(demangledSymbol), actual: \(entry.demangledSymbol)", file: fileWhereExecuted, line: lineWhereExecuted)
        XCTAssert(entry.address == expectedAddress, "Expected address: \(expectedAddress), actual: \(entry.address)", file: fileWhereExecuted, line: lineWhereExecuted)
    }
}
