#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

// Used as key for storing state of some resource.
public final class TrackedIdlingResource {
    // Unique identifier for tracked resource.
    public let identifier: UUID
    
    // Reference to a parent object that holds resource,
    // once it is deallocated, resource is considered free.
    // Parent can have different resources (with different identifiers).
    public weak var parent: AnyObject?
    
    public let resourceDescription: () -> TrackedIdlingResourceDescription
    
    private let untrackClosure: (TrackedIdlingResource) -> ()
    
    public init(
        identifier: UUID,
        parent: AnyObject,
        resourceDescription: @escaping () -> TrackedIdlingResourceDescription,
        untrack: @escaping (TrackedIdlingResource) -> ())
    {
        self.identifier = identifier
        self.parent = parent
        self.resourceDescription = resourceDescription
        self.untrackClosure = untrack
    }
    
    public convenience init(
        parent: AnyObject,
        resourceDescription: @escaping () -> TrackedIdlingResourceDescription,
        untrack: @escaping (TrackedIdlingResource) -> ())
    {
        self.init(
            identifier: UUID(),
            parent: parent,
            resourceDescription: resourceDescription,
            untrack: untrack
        )
    }
    
    deinit {
        untrack()
    }
    
    public func untrack() {
        untrackClosure(self)
    }
}

#endif
