#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public struct IntSize: Equatable {
    public var width: Int
    public var height: Int
    
    public init(
        width: Int,
        height: Int)
    {
        self.width = width
        self.height = height
    }
}

extension IntSize {
    public var area: Int {
        return width * height
    }
}

#endif
