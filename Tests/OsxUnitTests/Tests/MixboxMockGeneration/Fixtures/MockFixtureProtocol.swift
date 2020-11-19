import MixboxFoundation
import MixboxMocksRuntime
import MixboxTestsFoundation

class MockFixtureProtocol:
    MixboxMocksRuntime.BaseMock,
    FixtureProtocol,
    MixboxMocksRuntime.Mock
{
    class StubBuilder: MixboxMocksRuntime.StubBuilder {
        private let mockManager: MixboxMocksRuntime.MockManager
    
        required init(mockManager: MixboxMocksRuntime.MockManager) {
            self.mockManager = mockManager
        }
        
        func fixtureFunction<Argument0: MixboxMocksRuntime.Matcher, Argument1: MixboxMocksRuntime.Matcher>(_ argument0: Argument0, labeled argument1: Argument1) -> MixboxMocksRuntime.StubForFunctionBuilder<(Int, Int), Int>
            where
            Argument0.MatchingType == Int,
            Argument1.MatchingType == Int
        {
            let matcher = MixboxMocksRuntime.FunctionalMatcher<(Int, Int)>(
                matchingFunction: { (otherArgument0: Int, otherArgument1: Int) -> Bool in
                    argument0.valueIsMatching(otherArgument0) && argument1.valueIsMatching(otherArgument1)
                }
            )
        
            return MixboxMocksRuntime.StubForFunctionBuilder<(Int, Int), Int>(
                functionId:
                """
                fixtureFunction(_ unlabeled: Int, labeled: Int)
                """,
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
    
        func fixtureFunction<Argument0: MixboxMocksRuntime.Matcher, Argument1: MixboxMocksRuntime.Matcher>(_ argument0: Argument0, labeled argument1: Argument1)
            where
            Argument0.MatchingType == Int,
            Argument1.MatchingType == Int
        {
            let matcher = MixboxMocksRuntime.FunctionalMatcher<(Int, Int)>(
                matchingFunction: { (otherArgument0: Int, otherArgument1: Int) -> Bool in
                    argument0.valueIsMatching(otherArgument0) && argument1.valueIsMatching(otherArgument1)
                }
            )
        
            _ = mockManager.addExpecatation(
                functionId:
                """
                fixtureFunction(_ unlabeled: Int, labeled: Int)
                """,
                fileLine: fileLine,
                times: times,
                matcher: matcher
            )
        }
    }

    func fixtureFunction(_ argument0: Int, labeled argument1: Int) -> Int {
        return mockManager.call(
            functionId:
            """
            fixtureFunction(_ unlabeled: Int, labeled: Int)
            """,
            arguments: (argument0, argument1)
        )
    }
}
