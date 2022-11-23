#if MIXBOX_ENABLE_FRAMEWORK_DI && MIXBOX_DISABLE_FRAMEWORK_DI
#error("Di is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_DI || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_DI)
// The compilation is disabled
#else

// Like ErrorString from MixboxFoundation, but this module is not linked with MixboxFoundation.
public final class DiError: Error, CustomStringConvertible {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public var description: String {
        return value
    }
}

#endif
