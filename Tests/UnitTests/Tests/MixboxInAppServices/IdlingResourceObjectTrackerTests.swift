import Foundation
import MixboxInAppServices
import XCTest

final class IdlingResourceObjectTrackerTests: TestCase {
    private let object = NSObject()
    private let tracker = IdlingResourceObjectTracker()
    
    func test___tracker___is_idle___initially() {
        assertIsIdle()
    }
    
    func test___tracker___is_busy___if_resource_is_tracked() {
        let resource = tracker.track(parent: object)
        
        withExtendedLifetime(resource) {
            assertIsBusy()
        }
    }
    
    func test___tracker___is_idle___if_resource_is_tracked_and_then_untracked() {
        let resource = tracker.track(parent: object)
        
        withExtendedLifetime(resource) {
            resource.untrack()
            
            assertIsIdle()
        }
    }
    
    func test___tracker___is_idle___if_resource_is_tracked_and_then_parent_is_deallocated() {
        let resource: TrackedIdlingResource
        
        do {
            let temporaryObject = NSObject()
            resource = tracker.track(parent: temporaryObject)
        }
        
        withExtendedLifetime(resource) {
            assertIsIdle()
        }
    }
    
    func test___tracker___is_idle___if_resource_is_tracked_and_then_is_deallocated() {
        do {
            _ = tracker.track(parent: object)
        }
        
        assertIsIdle()
    }
    
    // There was a bug, when WeakBox was stored in a Set, and it was mutated,
    // so uniqueness of objects was violated and app was crashing.
    func test___tracker___is_idle___if_multiple_tracked_resources_are_deallocated() {
        do {
            _ = tracker.track(parent: object)
        }
        do {
            _ = tracker.track(parent: object)
        }
        
        assertIsIdle()
    }
    
    func test___tracker___works_properly___if_multiple_resource_are_tracked_and_then_untracked() {
        assertIsIdle()
        
        let resource1 = tracker.track(parent: object)
        
        withExtendedLifetime(resource1) {
            assertIsBusy()

            let resource2 = tracker.track(parent: object)
            
            withExtendedLifetime(resource2) {
                assertIsBusy()
                
                resource1.untrack()
                
                assertIsBusy()
                
                resource2.untrack()
                
                assertIsIdle()
            }
        }
    }
    
    private func assertIsIdle() {
        XCTAssertEqual(tracker.isIdle(), true)
    }
    
    private func assertIsBusy() {
        XCTAssertEqual(tracker.isIdle(), false)
    }
}
