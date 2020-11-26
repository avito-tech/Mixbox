import Foundation
import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerVerificationImpl: MockManagerVerification {
    private let testFailureRecorder: TestFailureRecorder
    private let callRecordsProvider: CallRecordsProvider
    private let waiter: RunLoopSpinningWaiter
    private let defaultTimeout: TimeInterval
    private let defaultPollingInterval: TimeInterval
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        callRecordsProvider: CallRecordsProvider,
        waiter: RunLoopSpinningWaiter,
        defaultTimeout: TimeInterval,
        defaultPollingInterval: TimeInterval)
    {
        self.testFailureRecorder = testFailureRecorder
        self.callRecordsProvider = callRecordsProvider
        self.waiter = waiter
        self.defaultTimeout = defaultTimeout
        self.defaultPollingInterval = defaultPollingInterval
    }
    
    public func verify<Arguments>(
        functionIdentifier: FunctionIdentifier,
        fileLine: FileLine,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher,
        argumentsMatcher: FunctionalMatcher<Arguments>,
        timeout: TimeInterval?,
        pollingInterval: TimeInterval?)
    {
        let argumentsMatcher = argumentsMatcher.byErasingType()
        let timeout = timeout ?? defaultTimeout
        let pollingInterval = pollingInterval ?? defaultPollingInterval
        
        if timeout > 0 {
            let shouldWait = shouldWaitForCalls(
                functionIdentifier: functionIdentifier,
                argumentsMatcher: argumentsMatcher,
                timesMethodWasCalledMatcher: timesMethodWasCalledMatcher
            )
            
            if shouldWait {
                waiter.wait(
                    timeout: timeout,
                    interval: pollingInterval,
                    while: { [weak self] in
                        guard let strongSelf = self else {
                            return false
                        }
                        
                        return strongSelf.shouldWaitForCalls(
                            functionIdentifier: functionIdentifier,
                            argumentsMatcher: argumentsMatcher,
                            timesMethodWasCalledMatcher: timesMethodWasCalledMatcher
                        )
                    }
                )
            }
        }
        
        let timesMethodIsCalled = callRecordsProvider.callRecords.mb_count {
            $0.functionIdentifier == functionIdentifier
                && argumentsMatcher.valueIsMatching($0.arguments)
        }
        
        switch timesMethodWasCalledMatcher.match(timesMethodIsCalled: timesMethodIsCalled) {
        case .match:
            break
        case .mismatch:
            testFailureRecorder.recordFailure(
                description: "Expectation was not fulfilled",
                fileLine: fileLine,
                shouldContinueTest: true
            )
        }
    }
    
    private func shouldWaitForCalls(
        functionIdentifier: FunctionIdentifier,
        argumentsMatcher: FunctionalMatcher<Any>,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher)
        -> Bool
    {
        let matchingResult = timesMethodWasCalledMatcher.match(
            timesMethodIsCalled: timesMethodIsCalled(
                functionIdentifier: functionIdentifier,
                argumentsMatcher: argumentsMatcher
            )
        )
        
        switch matchingResult {
        case .match:
            return false
        case let .mismatch(matchIsPossibleLater):
            return matchIsPossibleLater
        }
    }
    
    private func timesMethodIsCalled(
        functionIdentifier: FunctionIdentifier,
        argumentsMatcher: FunctionalMatcher<Any>)
        -> Int
    {
        return callRecordsProvider.callRecords.mb_count {
            $0.functionIdentifier == functionIdentifier
                && argumentsMatcher.valueIsMatching($0.arguments)
        }
    }
}
