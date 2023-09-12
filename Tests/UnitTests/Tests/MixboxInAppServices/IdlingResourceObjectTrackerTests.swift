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
        let resource = track(parent: object)
        
        withExtendedLifetime(resource) {
            assertIsBusy()
        }
    }
    
    func test___tracker___is_idle___if_resource_is_tracked_and_then_untracked() {
        let resource = track(parent: object)
        
        withExtendedLifetime(resource) {
            resource.untrack()
            
            assertIsIdle()
        }
    }
    
    func test___tracker___is_idle___if_resource_is_tracked_and_then_parent_is_deallocated() {
        let resource: TrackedIdlingResource
        
        do {
            let temporaryObject = NSObject()
            resource = track(parent: temporaryObject)
        }
        
        withExtendedLifetime(resource) {
            assertIsIdle()
        }
    }
    
    func test___tracker___is_idle___if_resource_is_tracked_and_then_is_deallocated() {
        do {
            _ = track(parent: object)
        }
        
        assertIsIdle()
    }
    
    // There was a bug, when WeakBox was stored in a Set, and it was mutated,
    // so uniqueness of objects was violated and app was crashing.
    func test___tracker___is_idle___if_multiple_tracked_resources_are_deallocated() {
        do {
            _ = track(parent: object)
        }
        do {
            _ = track(parent: object)
        }
        
        assertIsIdle()
    }
    
    func test___tracker___works_properly___if_multiple_resource_are_tracked_and_then_untracked() {
        assertIsIdle()
        
        let resource1 = track(parent: object)
        
        withExtendedLifetime(resource1) {
            assertIsBusy()

            let resource2 = track(parent: object)
            
            withExtendedLifetime(resource2) {
                assertIsBusy()
                
                resource1.untrack()
                
                assertIsBusy()
                
                resource2.untrack()
                
                assertIsIdle()
            }
        }
    }
    
    func test___resourceDescription___is_correct() {
        XCTAssertEqual(tracker.resourceDescription, "IdlingResourceObjectTracker {}")
        
        let parent: NSString = "nsstring"
        let resource = track(
            parent: parent,
            resourceDescription: {
                TrackedIdlingResourceDescription(
                    name: "name",
                    causeOfResourceBeingTracked: "causeOfResourceBeingTracked",
                    likelyCauseOfResourceStillBeingTracked: "likelyCauseOfResourceStillBeingTracked",
                    listOfConditionsThatWillCauseResourceToBeUntracked: ["condition 1", "condition 2"],
                    customProperties: [(key: "name", value: "duplicated name for whatever reason")]
                )
            }
        )
        
        XCTAssertEqual(
            tracker.resourceDescription,
            """
            IdlingResourceObjectTracker {
                \(resource.identifier): TrackedIdlingResource {
                    parent: nsstring,
                    name: name,
                    causeOfResourceBeingTracked: causeOfResourceBeingTracked,
                    likelyCauseOfResourceStillBeingTracked: likelyCauseOfResourceStillBeingTracked,
                    listOfConditionsThatWillCauseResourceToBeUntracked: {
                        - condition 1
                        - condition 2
                    },
                    name: duplicated name for whatever reason
                }
            }
            """
        )
    }
    
    private func track(
        parent: AnyObject,
        resourceDescription: @escaping () -> TrackedIdlingResourceDescription = {
            TrackedIdlingResourceDescription(
                name: "irrelevant",
                causeOfResourceBeingTracked: "irrelevant",
                likelyCauseOfResourceStillBeingTracked: "irrelevant",
                listOfConditionsThatWillCauseResourceToBeUntracked: ["irrelevant"]
            )
        }
    ) -> TrackedIdlingResource {
        tracker.track(
            parent: parent,
            resourceDescription: resourceDescription
        )
    }
    
    private func assertIsIdle() {
        XCTAssertEqual(tracker.isIdle(), true)
    }
    
    private func assertIsBusy() {
        XCTAssertEqual(tracker.isIdle(), false)
    }
}
