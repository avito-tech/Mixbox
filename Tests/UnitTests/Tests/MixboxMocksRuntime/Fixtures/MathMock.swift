import MixboxMocksRuntime
import MixboxFoundation

class MathMock:
    Math,
    MockType
{
    let mockManager: MixboxMocksRuntime.MockManager

    class StubBuilder: MixboxMocksRuntime.StubBuilder {
        private let mockManager: MixboxMocksRuntime.MockManager

        required init(mockManager: MixboxMocksRuntime.MockManager) {
            self.mockManager = mockManager
        }

        func sum<A1: MixboxMocksRuntime.Matcher, A2: MixboxMocksRuntime.Matcher>(
            _ a1: A1,
            b a2: A2)
            -> MixboxMocksRuntime.StubForFunctionBuilder<(Int, Int), Int>
            where
            A1.MatchingType == Int,
            A2.MatchingType == Int
        {
            let matcher = MixboxMocksRuntime.FunctionalMatcher<(Int, Int)>(
                matchingFunction: { (b1: Int, b2: Int) -> Bool in
                    a1.valueIsMatching(b1) && a2.valueIsMatching(b2)
                }
            )

            return MixboxMocksRuntime.StubForFunctionBuilder<(Int, Int), Int>(
                functionId: "sum(_ a: Int, b: Int)",
                mockManager: mockManager,
                matcher: matcher
            )
        }
    }

    class ExpectationBuilder: MixboxMocksRuntime.ExpectationBuilder {
        private let mockManager: MixboxMocksRuntime.MockManager
        private let times: MixboxMocksRuntime.FunctionalMatcher<Int>
        private let fileLine: MixboxFoundation.FileLine

        required init(
            mockManager: MixboxMocksRuntime.MockManager,
            times: MixboxMocksRuntime.FunctionalMatcher<Int>,
            fileLine: MixboxFoundation.FileLine)
        {
            self.mockManager = mockManager
            self.times = times
            self.fileLine = fileLine
        }

        func sum<A1: MixboxMocksRuntime.Matcher, A2: MixboxMocksRuntime.Matcher>(
            _ a1: A1,
            b a2: A2)
            where
            A1.MatchingType == Int,
            A2.MatchingType == Int
        {
            let matcher = MixboxMocksRuntime.FunctionalMatcher<(Int, Int)>(
                matchingFunction: { (b1: Int, b2: Int) -> Bool in
                    a1.valueIsMatching(b1) && a2.valueIsMatching(b2)
                }
            )

            mockManager.addExpecatation(
                functionId: "sum(_ a: Int, b: Int)",
                fileLine: fileLine,
                times: times,
                matcher: matcher
            )
        }
    }

    init(mockManager: MixboxMocksRuntime.MockManager) {
        self.mockManager = mockManager
    }

    convenience init(file: StaticString = #file, line: UInt = #line) {
        self.init(
            mockManager: MixboxMocksRuntime.MockManagerImpl(
                fileLine: MixboxFoundation.FileLine(
                    file: file,
                    line: line
                )
            )
        )
    }

    func sum(
        _ a1: Int,
        b a2: Int)
        -> Int
    {
        return mockManager.call(
            functionId: "sum(_ a: Int, b: Int)",
            arguments: (
                a1,
                a2
            )
        )
    }
}
