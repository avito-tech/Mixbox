import MixboxGray
import XCTest

final class RunLoopSpinnerTests: TestCase {
    func test() {
        var conditionMetHandlerIsCalled = false
        
        let runLoopSpinner = RunLoopSpinnerImpl(
            timeout: TimeInterval.greatestFiniteMagnitude,
            minRunLoopDrains: 0,
            maxSleepInterval: TimeInterval.greatestFiniteMagnitude,
            runLoopModesStackProvider: RunLoopModesStackProviderImpl(),
            conditionMetHandler: {
                conditionMetHandlerIsCalled = true
            }
        )
        
        var shouldStopSpinning = false
        var spinned = false
        let startedDate = Date()
        let timeIntervalToStopSpinning: TimeInterval = 5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntervalToStopSpinning) {
            shouldStopSpinning = true
        }
        
        let metCondition = runLoopSpinner.spin(
            until: {
                spinned = true
                return shouldStopSpinning
            }
        )
        
        let stoppedDate = Date()
    
        XCTAssertEqual(metCondition, true)
        XCTAssertEqual(shouldStopSpinning, true)
        XCTAssertEqual(spinned, true)
        XCTAssertEqual(conditionMetHandlerIsCalled, true)
        
        XCTAssertGreaterThanOrEqual(
            stoppedDate.timeIntervalSinceNow,
            startedDate.timeIntervalSinceNow + timeIntervalToStopSpinning
        )
    }
}
