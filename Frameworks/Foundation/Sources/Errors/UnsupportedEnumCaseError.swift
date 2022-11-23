#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class UnsupportedEnumCaseError: Error, CustomStringConvertible {
    private let message: String
    
    public init<T>(_ enumCaseValue: T) {
        message = "Unsupported case of \(T.self): \(enumCaseValue)"
    }
    
    public var description: String {
        return message
    }
}

#endif
