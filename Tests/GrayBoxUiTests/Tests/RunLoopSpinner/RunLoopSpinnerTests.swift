// TODO: Move to hosted-app logic tests

import MixboxTestsFoundation
import XCTest
import MixboxFoundation

// TODO: Test different runloop modes
// TODO: Add more tests
final class RunLoopSpinnerTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    func test___spinning_can_be_stopped() {
        spinUntilShouldStopSpinningEqualsTrue(
            stopSpinningAfterSomeTime: true
        )
        
        assert(
            result: .stopConditionMet,
            spinned: true,
            shouldStopSpinning: true,
            conditionMetHandlerIsCalled: true
        )
        
        assert(spinnedLongerThanOrEqualTo: timeIntervalToStopSpinning)
        assert(spinnedFasterThan: timeout)
    }
    
    func test___spinning_can_be_timed_out() {
        spinUntilShouldStopSpinningEqualsTrue()
        
        assert(
            result: .timedOut,
            spinned: true,
            shouldStopSpinning: false,
            conditionMetHandlerIsCalled: false
        )
        
        assert(spinnedLongerThanOrEqualTo: timeout)
    }
    
    func test___is_not_timed_out_if_timeout_is_0_or_less_but_condition_is_met() {
        shouldStopSpinning = true
        
        spinUntilShouldStopSpinningEqualsTrue(
            timeout: 0
        )
        
        assert(
            result: .stopConditionMet,
            spinned: true,
            shouldStopSpinning: true,
            conditionMetHandlerIsCalled: true
        )
        
        let expectedSpinningTime: TimeInterval = 0
        let accuracyToCopeWithProbableHighLoadOnCi: TimeInterval = 5
        
        assert(spinnedLongerThanOrEqualTo: expectedSpinningTime)
        assert(spinnedFasterThan: expectedSpinningTime + accuracyToCopeWithProbableHighLoadOnCi)
    }
    
    // MARK: - Private / Given
    
    private var conditionMetHandlerIsCalled = false
    
    private var shouldStopSpinning = false
    private var spinned = false
    private var startedDate: Date?
    private var stoppedDate: Date?
    private var spinUntilResult: SpinUntilResult?
    private var timeout: TimeInterval = defaultTimeout
    private let timeIntervalToStopSpinning: TimeInterval = 5
    
    private static let defaultTimeout: TimeInterval = 15
    private static let defaultMinRunLoopDrains: Int = 0
    private static let defaultMaxSleepInterval: TimeInterval = TimeInterval.greatestFiniteMagnitude
    
    // MARK: - Private / When
    
    private func spinUntilShouldStopSpinningEqualsTrue(
        stopSpinningAfterSomeTime: Bool = false,
        timeout: TimeInterval = defaultTimeout,
        minRunLoopDrains: Int = defaultMinRunLoopDrains,
        maxSleepInterval: TimeInterval = defaultMaxSleepInterval)
    {
        startedDate = Date()
        
        if stopSpinningAfterSomeTime {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeIntervalToStopSpinning) { [weak self] in
                self?.shouldStopSpinning = true
            }
        }
        
        self.timeout = timeout
        
        let runLoopSpinner = RunLoopSpinnerImpl(
            timeout: timeout,
            minRunLoopDrains: minRunLoopDrains,
            maxSleepInterval: maxSleepInterval,
            runLoopModesStackProvider: RunLoopModesStackProviderImpl(),
            conditionMetHandler: { [weak self] in
                self?.conditionMetHandlerIsCalled = true
            }
        )
        
        spinUntilResult = runLoopSpinner.spinUntil { [weak self] in
            self?.spinned = true
            return self?.shouldStopSpinning ?? true
        }
        
        stoppedDate = Date()
    }
    
    // MARK: - Private / Then
    
    private func assert(spinnedFasterThan timeInterval: TimeInterval) {
        guard let actualTimeSpinned = actualTimeSpinned else {
            XCTFail("actualTimeSpinned == nil")
            return
        }
        
        XCTAssertLessThan(
            actualTimeSpinned,
            timeInterval
        )
    }
    
    private func assert(spinnedLongerThanOrEqualTo timeInterval: TimeInterval) {
        guard let actualTimeSpinned = actualTimeSpinned else {
            XCTFail("actualTimeSpinned == nil")
            return
        }
        
        XCTAssertGreaterThanOrEqual(
            actualTimeSpinned,
            timeInterval
        )
    }
    
    private func assert(
        result: SpinUntilResult,
        spinned: Bool,
        shouldStopSpinning: Bool,
        conditionMetHandlerIsCalled: Bool)
    {
        XCTAssertEqual(self.spinUntilResult, result, "spinUntilResult mismatches")
        XCTAssertEqual(self.shouldStopSpinning, shouldStopSpinning, "shouldStopSpinning mismatches")
        XCTAssertEqual(self.spinned, spinned, "spinned mismatches")
        XCTAssertEqual(self.conditionMetHandlerIsCalled, conditionMetHandlerIsCalled, "conditionMetHandlerIsCalled mismatches")
    }
    
    private var actualTimeSpinned: TimeInterval? {
        guard let startedDate = startedDate, let stoppedDate = stoppedDate else {
            return nil
        }
        
        return stoppedDate.timeIntervalSinceNow - startedDate.timeIntervalSinceNow
    }
}
