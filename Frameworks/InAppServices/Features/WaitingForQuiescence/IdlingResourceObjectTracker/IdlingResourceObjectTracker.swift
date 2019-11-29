#if MIXBOX_ENABLE_IN_APP_SERVICES

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
public final class IdlingResourceObjectTracker: IdlingResource {
    // TODO: Inject `IdlingResourceObjectTracker` in swizzlers, keep singletons near swizzlers.
    public static let instance = IdlingResourceObjectTracker()
    
    private var busyObjects: Set<IdlingResourceObject> = []
    
    public init() {
    }
    
    public func track(object: AnyObject, state: IdlingResourceObjectState) {
        let idlingResourceObject = IdlingResourceObject(object: object)
        
        switch state {
        case .idle:
            busyObjects.remove(idlingResourceObject)
        case .busy:
            busyObjects.insert(idlingResourceObject)
        }
    }
    
    public func isIdle() -> Bool {
        var newBusyObjects = busyObjects
        
        for idlingResourceObject in busyObjects where idlingResourceObject.object == nil {
            newBusyObjects.remove(idlingResourceObject)
        }
        
        busyObjects = newBusyObjects
        
        return newBusyObjects.isEmpty
    }
}

#endif
