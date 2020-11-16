import MixboxMocksRuntime
import MixboxFoundation
import MixboxTestsFoundation

class MockFixtureProtocol:
    FixtureProtocol,
    MixboxMocksRuntime.MockType
{
    let mockManager: MixboxMocksRuntime.MockManager
    
    class StubBuilder: MixboxMocksRuntime.StubBuilder {
        private let mockManager: MixboxMocksRuntime.MockManager
    
        required init(mockManager: MixboxMocksRuntime.MockManager) {
            self.mockManager = mockManager
        }
        
        func fixtureFunction<A0: MixboxMocksRuntime.Matcher, A1: MixboxMocksRuntime.Matcher>(_ a0: A0, labeled a1: A1) -> MixboxMocksRuntime.StubForFunctionBuilder<(Int, Int), Int>
            where
            A0.MatchingType == Int,
            A1.MatchingType == Int
        {
            let matcher = MixboxMocksRuntime.FunctionalMatcher<(Int, Int)>(
                matchingFunction: { (b0: Int, b1: Int) -> Bool in
                    a0.valueIsMatching(b0) && a1.valueIsMatching(b1)
                }
            )
        
            return MixboxMocksRuntime.StubForFunctionBuilder<(Int, Int), Int>(
                functionId: "fixtureFunction(_ unlabeled: Int, labeled: Int)",
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
    
        func fixtureFunction<A0: MixboxMocksRuntime.Matcher, A1: MixboxMocksRuntime.Matcher>(_ a0: A0, labeled a1: A1)
            where
            A0.MatchingType == Int,
            A1.MatchingType == Int
        {
            let matcher = MixboxMocksRuntime.FunctionalMatcher<(Int, Int)>(
                matchingFunction: { (b0: Int, b1: Int) -> Bool in
                    a0.valueIsMatching(b0) && a1.valueIsMatching(b1)
                }
            )
        
            mockManager.addExpecatation(
                functionId: "fixtureFunction(_ unlabeled: Int, labeled: Int)",
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

    func fixtureFunction(_ a0: Int, labeled a1: Int) -> Int {
        return try mockManager.call(
            functionId: "fixtureFunction(_ unlabeled: Int, labeled: Int)",
            arguments: (a0, a1)
        )
    }
}
