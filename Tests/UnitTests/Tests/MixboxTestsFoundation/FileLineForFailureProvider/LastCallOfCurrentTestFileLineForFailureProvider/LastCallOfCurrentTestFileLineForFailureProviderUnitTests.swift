import XCTest
import MixboxTestsFoundation

final class LastCallOfCurrentTestFileLineForFailureProviderUnitTests: XCTestCase {
    func test_example() {
        parameterized_test(
            trace: [],
            patterns: [],
            fileLine: nil
        )
    }
    
    func test_returnsNil_0() {
        parameterized_test(
            trace: [],
            patterns: [],
            fileLine: nil
        )
    }
    
    func test_returnsNil_1() {
        parameterized_test(
            trace: [
                entry(
                    line: nil,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["x"],
            fileLine: nil
        )
    }
    
    func test_returnsNil_2() {
        parameterized_test(
            trace: [
                entry(
                    file: nil,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["x"],
            fileLine: nil
        )
    }
    
    func test_returnsFileLine_0() {
        parameterized_test(
            trace: [
                entry(
                    file: "file",
                    line: 42,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["x"],
            fileLine: HeapFileLine(
                file: "file",
                line: 42
            )
        )
    }
    
    func test_returnsFileLine_1() {
        parameterized_test(
            trace: [
                entry(
                    file: "child",
                    line: 1,
                    demangledSymbol: "x"
                ),
                entry(
                    file: "parent",
                    line: 2,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["x"],
            fileLine: HeapFileLine(
                file: "parent",
                line: 2
            )
        )
    }
    
    func test_returnsFileLine_2() {
        parameterized_test(
            trace: [
                entry(
                    file: "samefile",
                    line: 1, // child
                    demangledSymbol: "x"
                ),
                entry(
                    file: "samefile",
                    line: 2,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["x"],
            fileLine: HeapFileLine(
                file: "samefile",
                line: 1 // child
            )
        )
    }
    
    func test_returnsFileLine_3() {
        parameterized_test(
            trace: [
                entry(
                    file: "samefile",
                    line: 1,
                    demangledSymbol: "y"
                ),
                entry(
                    file: "samefile",
                    line: 2,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["x"],
            fileLine: HeapFileLine(
                file: "samefile",
                line: 2
            )
        )
    }
    
    func test_fallbacks_0() {
        parameterized_test(
            trace: [
                entry(
                    file: "samefile",
                    line: 1,
                    demangledSymbol: "x"
                ),
                entry(
                    file: "samefile",
                    line: 2,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["nothing-matches-me"],
            fileLine: HeapFileLine(
                file: "samefile",
                line: 1
            )
        )
    }
    
    func test_fallbacks_1() {
        parameterized_test(
            trace: [
                entry(
                    file: "samefile",
                    line: 1,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["nothing-matches-me"],
            fileLine: HeapFileLine(
                file: "samefile",
                line: 1
            )
        )
    }
    
    func test_fallbacks_2() {
        parameterized_test(
            trace: [
                entry(
                    file: "samefile",
                    line: 1,
                    demangledSymbol: "x"
                ),
                entry(
                    file: "samefile",
                    line: 2,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["nothing-matches-me"],
            fileLine: HeapFileLine(
                file: "samefile",
                line: 1
            )
        )
    }
    
    func test_fallbacks_3() {
        parameterized_test(
            trace: [
                entry(
                    file: "child",
                    line: 1,
                    demangledSymbol: "x"
                ),
                entry(
                    file: "parent",
                    line: 2,
                    demangledSymbol: "x"
                )
            ],
            patterns: ["nothing-matches-me"],
            fileLine: HeapFileLine(
                file: "parent",
                line: 2
            )
        )
    }
    
    func test_fallbacks_4() {
        parameterized_test(
            trace: [
                entry(
                    file: "bob",
                    line: 1
                ),
                entry(
                    file: "alice", // <- last call of parent
                    line: 2
                ),
                entry(
                    file: "bob",
                    line: 3
                ),
                entry(
                    file: "alice", // <- parent
                    line: 4
                )
            ],
            patterns: ["nothing-matches-me"],
            fileLine: HeapFileLine(
                file: "alice",
                line: 2
            )
        )
    }
    
    private func entry(
        file: String? = random(),
        line: UInt64? = random(),
        demangledSymbol: String? = random())
        -> ExtendedStackTraceEntry
    {
        return ExtendedStackTraceEntry(
            file: file,
            line: line,
            owner: random(),
            symbol: random(),
            demangledSymbol: demangledSymbol,
            address: random()
        )
    }
    
    func parameterized_test(
        trace: [ExtendedStackTraceEntry],
        patterns: [String],
        fileLine: HeapFileLine?,
        file: StaticString = #file,
        line: UInt = #line)
    {
        let provider = LastCallOfCurrentTestFileLineForFailureProvider(
            extendedStackTraceProvider: ExtendedStackTraceProviderMock(
                extendedStackTrace: trace
            ),
            testSymbolPatterns: patterns
        )
        
        XCTAssertEqual(provider.fileLineForFailure(), fileLine, file: file, line: line)
    }
}

private func random() -> UInt64 {
    return UInt64(arc4random())
}

private func random() -> String? {
    if arc4random() % 2 == 0 {
        return nil
    } else {
        return "tbd: random?"
    }
}
