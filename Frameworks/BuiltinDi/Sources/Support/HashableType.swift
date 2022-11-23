#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_DI && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_DI
#error("BuiltinDi is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_DI || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_DI)
// The compilation is disabled
#else

final class HashableType: Hashable {
    private let type: Any.Type
    
    init(type: Any.Type) {
        self.type = type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(type)")
    }
    
    static func ==(lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.type == rhs.type
    }
}

#endif
