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
    
    private var threadUnsafeBusyResources: [UUID: WeakBox<TrackedIdlingResource>] = [:]
    private let readWriteLock = ReadWriteLock()
    
    public init() {
    }
    
    public func track(
        parent: AnyObject,
        resourceDescription: @escaping () -> TrackedIdlingResourceDescription
    ) -> TrackedIdlingResource {
        let resource = TrackedIdlingResource(
            parent: parent,
            resourceDescription: resourceDescription,
            untrack: { [weak self] resource in
                self?.untrack(identifier: resource.identifier)
            }
        )
        
        readWriteLock.write {
            threadUnsafeBusyResources[resource.identifier] = WeakBox(resource)
        }
        
        return resource
    }
    
    public func isIdle() -> Bool {
        let oldResources = readWriteLock.read {
            threadUnsafeBusyResources
        }
        
        var newResources = oldResources
        
        for (identifier, resourceBox) in oldResources where resourceOrItsParentIsDeallocated(resourceBox) {
            newResources[identifier] = nil
        }
        
        if newResources.count != oldResources.count {
            readWriteLock.write {
                threadUnsafeBusyResources = newResources
            }
        }
        
        return newResources.isEmpty
    }
    
    public var resourceDescription: String {
        let busyResources = readWriteLock.read {
            threadUnsafeBusyResources
        }
        
        let wrappedChildrenDescription = busyResources.map { uuid, trackedIdlingResourceWeakBox in
            "\(uuid.uuidString): \(resourceDescription(trackedIdlingResourceWeakBox: trackedIdlingResourceWeakBox))"
        }.joined(separator: ",\n").mb_wrapAndIndent(prefix: "{", postfix: "}", ifEmpty: "{}")
        
        return "IdlingResourceObjectTracker \(wrappedChildrenDescription)"
    }
    
    private func untrack(identifier: UUID) {
        readWriteLock.write {
            threadUnsafeBusyResources[identifier] = nil
        }
    }
    
    private func resourceDescription(trackedIdlingResourceWeakBox: WeakBox<TrackedIdlingResource>) -> String {
        if let value = trackedIdlingResourceWeakBox.value {
            return resourceDescription(trackedIdlingResource: value)
        } else {
            return "nil"
        }
    }

    private func resourceDescription(trackedIdlingResource: TrackedIdlingResource) -> String {
        var properties = [(key: String, value: String)]()
        
        if let parent = trackedIdlingResource.parent {
            properties.append((key: "parent", value: String(describing: parent)))
        }
        
        let resourceDescription = trackedIdlingResource.resourceDescription()
        
        properties.append((key: "name", value: resourceDescription.name))
        properties.append((key: "causeOfResourceBeingTracked", value: resourceDescription.causeOfResourceBeingTracked))
        properties.append((key: "likelyCauseOfResourceStillBeingTracked", value: resourceDescription.likelyCauseOfResourceStillBeingTracked))
        properties.append(
            (
                key: "listOfConditionsThatWillCauseResourceToBeUntracked",
                value: resourceDescription.listOfConditionsThatWillCauseResourceToBeUntracked.map {
                    "- \($0)"
                }.joined(
                    separator: "\n"
                ).mb_wrapAndIndent(
                    prefix: "{",
                    postfix: "}",
                    ifEmpty: "ERROR: no conditions given, `listOfConditionsThatWillCauseResourceToBeUntracked` is empty, please, fix it in Mixbox"
                )
            )
        )
        
        properties.append(contentsOf: resourceDescription.customProperties)
        
        return "TrackedIdlingResource " + properties.map {
            "\($0.key): \($0.value)"
        }.joined(separator: ",\n").mb_wrapAndIndent(prefix: "{", postfix: "}", ifEmpty: "{}")
    }

    private func resourceDescription(trackedIdlingResourceParent: Any?) -> String {
        if let trackedIdlingResourceParent {
            return String(describing: trackedIdlingResourceParent)
        } else {
            return "nil"
        }
    }
    
    private func resourceOrItsParentIsDeallocated(_ box: WeakBox<TrackedIdlingResource>) -> Bool {
        return box.value?.parent == nil
    }
}

#endif
