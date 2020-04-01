#if MIXBOX_ENABLE_IN_APP_SERVICES

// Used as key for storing state of some resource.
public final class TrackedIdlingResource {
    // Unique identifier for tracked resource.
    public let identifier: UUID
    
    // Reference to an parent object that holds resource,
    // once it is deallocated, resource is considered free.
    // Parent can have different resources (with different identifiers).
    public weak var parent: AnyObject?
    
    private let untrackClosure: (TrackedIdlingResource) -> ()
    
    public init(
        identifier: UUID,
        parent: AnyObject,
        untrack: @escaping (TrackedIdlingResource) -> ())
    {
        self.identifier = identifier
        self.parent = parent
        self.untrackClosure = untrack
    }
    
    public convenience init(
        parent: AnyObject,
        untrack: @escaping (TrackedIdlingResource) -> ())
    {
        self.init(
            identifier: UUID(),
            parent: parent,
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
