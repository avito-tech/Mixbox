#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class RunLoopModesStackProviderImpl: RunLoopModesStackProvider {
    public init() {
    }
    
    // TODO: Good implementation (e.g. steal from EarlGrey)
    public var runLoopModes: [CFRunLoopMode] {
        return RunLoop.current.currentMode.map { [CFRunLoopMode(rawValue: $0.rawValue as CFString)] } ?? []
    }
}

#endif
