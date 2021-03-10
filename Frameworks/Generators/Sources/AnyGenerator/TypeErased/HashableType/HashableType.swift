// NOTE: Copypasted from MixboxBuiltinDi

#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class HashableType: Hashable {
    private let type: Any.Type
    
    public init(type: Any.Type) {
        self.type = type
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(type)")
    }
    
    public static func ==(lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.type == rhs.type
    }
}

#endif
