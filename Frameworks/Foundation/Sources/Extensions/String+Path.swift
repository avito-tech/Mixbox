#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

extension String {
    public var mb_deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    public func mb_appendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    public var mb_lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var mb_resolvingSymlinksInPath: String {
        return (self as NSString).resolvingSymlinksInPath
    }
}

#endif
