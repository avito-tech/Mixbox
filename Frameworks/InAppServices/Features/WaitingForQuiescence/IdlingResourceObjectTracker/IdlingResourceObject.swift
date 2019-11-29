#if MIXBOX_ENABLE_IN_APP_SERVICES

// Used as key for storing state of some resource (.idle/.busy)
public final class IdlingResourceObject: Hashable {
    public let identifier: ObjectIdentifier
    public weak var object: AnyObject?
    
    public init(
        identifier: ObjectIdentifier,
        object: AnyObject)
    {
        self.identifier = identifier
        self.object = object
    }
    
    public convenience init(
        object: AnyObject)
    {
        self.init(
            identifier: ObjectIdentifier(object),
            object: object
        )
    }
    
    public static func ==(lhs: IdlingResourceObject, rhs: IdlingResourceObject) -> Bool {
        return lhs.object === rhs.object
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

#endif
