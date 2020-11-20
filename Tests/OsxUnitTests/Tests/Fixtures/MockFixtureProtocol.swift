// swiftlint:disable all

import MixboxFoundation
import MixboxMocksRuntime
import MixboxTestsFoundation

class MockFixtureProtocol:
    MixboxMocksRuntime.BaseMock,
    FixtureProtocol,
    MixboxMocksRuntime.Mock
{
    class StubbingBuilder: MixboxMocksRuntime.StubbingBuilder {
        private let mockManager: MixboxMocksRuntime.MockManager
        private let fileLine: FileLine
        
        required init(mockManager: MixboxMocksRuntime.MockManager, fileLine: FileLine) {
            self.mockManager = mockManager
            self.fileLine = fileLine
        }
        
        func fixtureFunction<Argument0: MixboxMocksRuntime.Matcher, Argument1: MixboxMocksRuntime.Matcher>(
            _ argument0: Argument0,
            labeled argument1: Argument1)
            -> MixboxMocksRuntime.StubbingFunctionBuilder<(Int, Int), Int>
            where
            Argument0.MatchingType == Int,
            Argument1.MatchingType == Int
        {
            let argumentsMatcher = MixboxMocksRuntime.FunctionalMatcher<(Int, Int)>(
                matchingFunction: { (otherArgument0: Int, otherArgument1: Int) -> Bool in
                    argument0.valueIsMatching(otherArgument0) && argument1.valueIsMatching(otherArgument1)
                }
            )
        
            return MixboxMocksRuntime.StubbingFunctionBuilder<(Int, Int), Int>(
                functionIdentifier:
                """
                fixtureFunction(_ unlabeled: Int, labeled: Int)
                """,
                mockManager: mockManager,
                argumentsMatcher: argumentsMatcher,
                fileLine: fileLine
            )
        }
    }

    class VerificationBuilder: MixboxMocksRuntime.VerificationBuilder {
        private let mockManager: MixboxMocksRuntime.MockManager
        private let fileLine: FileLine
        
        required init(mockManager: MixboxMocksRuntime.MockManager, fileLine: FileLine) {
            self.mockManager = mockManager
            self.fileLine = fileLine
        }
        
        func fixtureFunction<Argument0: MixboxMocksRuntime.Matcher, Argument1: MixboxMocksRuntime.Matcher>(
            _ argument0: Argument0,
            labeled argument1: Argument1)
            -> MixboxMocksRuntime.VerificationFunctionBuilder<(Int, Int), Int>
            where
            Argument0.MatchingType == Int,
            Argument1.MatchingType == Int
        {
            let argumentsMatcher = MixboxMocksRuntime.FunctionalMatcher<(Int, Int)>(
                matchingFunction: { (otherArgument0: Int, otherArgument1: Int) -> Bool in
                    argument0.valueIsMatching(otherArgument0) && argument1.valueIsMatching(otherArgument1)
                }
            )
        
            return MixboxMocksRuntime.VerificationFunctionBuilder<(Int, Int), Int>(
                functionIdentifier:
                """
                fixtureFunction(_ unlabeled: Int, labeled: Int)
                """,
                mockManager: mockManager,
                argumentsMatcher: argumentsMatcher,
                fileLine: fileLine
            )
        }
    }

    func fixtureFunction(_ argument0: Int, labeled argument1: Int) -> Int {
        return getMockManager().call(
            functionIdentifier:
            """
            fixtureFunction(_ unlabeled: Int, labeled: Int)
            """,
            arguments: (argument0, argument1)
        )
    }
}
