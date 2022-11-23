#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

// Tracks state of objects. Objects are used as keys and stored weakly.
//
// Example of usage:
//
// - Scroll view starts being dragged.
// - You call track(object: scrollView, state: .busy)
// - Scroll view stops being dragged.
// - Scroll view starts decelerating.
// - Scroll view stops decelerating.
// - You call track(object: scrollView, state: .idle)
// - So you can interact with UI safely, because it is stable
//
// This class is not thread safe. It should be used from main thread only.
// If you want to make it thread safe, change interface to asynchronous.
//
public final class IdlingResourceObjectTracker: IdlingResource {
    // TODO: Inject `IdlingResourceObjectTracker` in swizzlers, keep singletons near swizzlers.
    public static let instance = IdlingResourceObjectTracker()
    
    private var busyResources: [UUID: WeakBox<TrackedIdlingResource>] = [:]
    
    public init() {
    }
    
    public func track(parent: AnyObject) -> TrackedIdlingResource {
        let resource = TrackedIdlingResource(
            parent: parent,
            untrack: { [weak self] resource in
                self?.busyResources[resource.identifier] = nil
            }
        )
        
        busyResources[resource.identifier] = WeakBox(resource)
        
        return resource
    }
    
    public func isIdle() -> Bool {
        var newResources = busyResources
        
        for (identifier, resourceBox) in busyResources where resourceOrItsParentIsDeallocated(resourceBox) {
            newResources[identifier] = nil
        }
        
        busyResources = newResources
        
        return newResources.isEmpty
    }
    
    private func resourceOrItsParentIsDeallocated(_ box: WeakBox<TrackedIdlingResource>) -> Bool {
        return box.value?.parent == nil
    }
}

#endif
