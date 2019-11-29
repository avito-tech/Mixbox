import Foundation
import MixboxInAppServices
import XCTest

final class IdlingResourceObjectTrackerTests: TestCase {
    private let object = NSObject()
    private let tracker = IdlingResourceObjectTracker()
    
    func test___tracker___is_idle___initially() {
        assertIsIdle()
    }
    
    func test___tracker___is_idle___if_idle_resource_is_inserted() {
        tracker.track(object: object, state: .idle)
        
        assertIsIdle()
    }
    
    func test___tracker___is_idle___if_busy_resource_is_inserted_and_become_idle() {
        tracker.track(object: object, state: .busy)
        tracker.track(object: object, state: .idle)
        
        assertIsIdle()
    }
    
    func test___tracker___is_idle___if_busy_resource_is_inserted_twice_and_become_idle() {
        tracker.track(object: object, state: .busy)
        tracker.track(object: object, state: .idle)
        
        assertIsIdle()
    }
    
    func test___tracker___is_idle___if_busy_resource_is_inserted_and_then_deallocated() {
        tracker.track(object: NSObject(), state: .busy)
        
        assertIsIdle()
    }
    
    func test___tracker___is_busy___if_busy_resource_is_inserted() {
        tracker.track(object: object, state: .busy)
        
        assertIsBusy()
    }
    
    func test___tracker___is_busy___if_resource_switches_states_multiple_times_to_busy() {
        tracker.track(object: object, state: .busy)
        tracker.track(object: object, state: .idle)
        tracker.track(object: object, state: .busy)
        
        assertIsBusy()
    }
    
    func test___tracker___is_busy___if_resource_becomes_idle_and_other_is_inserted_as_busy() {
        tracker.track(object: object, state: .busy)
        tracker.track(object: object, state: .idle)
        
        let otherObject = NSObject()
        tracker.track(object: otherObject, state: .busy)
        
        assertIsBusy()
    }
    
    func test___tracker___is_busy___if_resource_is_inserted_as_busy_and_other_becomes_idle() {
        let otherObject = NSObject()
        tracker.track(object: otherObject, state: .busy)
        
        tracker.track(object: object, state: .busy)
        tracker.track(object: object, state: .idle)
        
        assertIsBusy()
    }
    
    private func assertIsIdle() {
        XCTAssertEqual(tracker.isIdle(), true)
    }
    
    private func assertIsBusy() {
        XCTAssertEqual(tracker.isIdle(), false)
    }
}
