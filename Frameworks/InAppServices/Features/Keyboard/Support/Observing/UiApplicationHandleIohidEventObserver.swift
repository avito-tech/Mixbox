#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class UiApplicationHandleIohidEventObserver: Hashable {
    public let uiApplicationHandledIohidEvent: (_ iohidEvent: IOHIDEventRef) -> ()
    private let uniqueNumberForHash: UInt32
    
    public init(
        uiApplicationHandledIohidEvent: @escaping (_ iohidEvent: IOHIDEventRef) -> ())
    {
        self.uiApplicationHandledIohidEvent = uiApplicationHandledIohidEvent
        self.uniqueNumberForHash = arc4random()
    }
    
    public static func == (lhs: UiApplicationHandleIohidEventObserver, rhs: UiApplicationHandleIohidEventObserver) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueNumberForHash)
    }
}

#endif
