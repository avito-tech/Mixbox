// NOTE: Copypasted from MixboxBuiltinDi

#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

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
