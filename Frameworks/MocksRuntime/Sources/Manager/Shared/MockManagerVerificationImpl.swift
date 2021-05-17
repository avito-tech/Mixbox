import Foundation
import MixboxFoundation
import MixboxTestsFoundation

public final class MockManagerVerificationImpl: MockManagerVerification {
    private let testFailureRecorder: TestFailureRecorder
    private let recordedCallsProvider: RecordedCallsProvider
    private let waiter: RunLoopSpinningWaiter
    private let defaultTimeout: TimeInterval
    private let defaultPollingInterval: TimeInterval
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        recordedCallsProvider: RecordedCallsProvider,
        waiter: RunLoopSpinningWaiter,
        defaultTimeout: TimeInterval,
        defaultPollingInterval: TimeInterval)
    {
        self.testFailureRecorder = testFailureRecorder
        self.recordedCallsProvider = recordedCallsProvider
        self.waiter = waiter
        self.defaultTimeout = defaultTimeout
        self.defaultPollingInterval = defaultPollingInterval
    }
    
    public func verify(
        functionIdentifier: FunctionIdentifier,
        fileLine: FileLine,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher,
        recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>,
        timeout: TimeInterval?,
        pollingInterval: TimeInterval?)
    {
        let timeout = timeout ?? defaultTimeout
        let pollingInterval = pollingInterval ?? defaultPollingInterval
        
        if timeout > 0 {
            let shouldWait = shouldWaitForCalls(
                functionIdentifier: functionIdentifier,
                recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
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
                            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
                            timesMethodWasCalledMatcher: timesMethodWasCalledMatcher
                        )
                    }
                )
            }
        }
        
        let timesMethodIsCalled = self.timesMethodIsCalled(
            functionIdentifier: functionIdentifier,
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher
        )
        
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
        recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>,
        timesMethodWasCalledMatcher: TimesMethodWasCalledMatcher)
        -> Bool
    {
        let matchingResult = timesMethodWasCalledMatcher.match(
            timesMethodIsCalled: timesMethodIsCalled(
                functionIdentifier: functionIdentifier,
                recordedCallArgumentsMatcher: recordedCallArgumentsMatcher
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
        recordedCallArgumentsMatcher: Matcher<RecordedCallArguments>)
        -> Int
    {
        return recordedCallsProvider.recordedCalls.mb_count {
            $0.functionIdentifier == functionIdentifier
                && recordedCallArgumentsMatcher.match(value: $0.arguments).matched
        }
    }
}
