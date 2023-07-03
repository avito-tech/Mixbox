#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

// To raise compile time error when version is removed from this class.
// This way we can drop dead code.
public final class MixboxIosVersions {
    private init() {
    }
    
    // These versions are checked on CI and work (at least tests are passing)
    public final class Supported {
        public static var iOS14: IosVersion { IosVersion(major: 14) }
        public static var iOS15: IosVersion { IosVersion(major: 15) }
        public static var iOS16: IosVersion { IosVersion(major: 16) }
    }
    
    // These versions may or may not work, but support is not dropped completely
    public final class Outdated {
        public static var iOS10: IosVersion { IosVersion(major: 10) }
        public static var iOS11: IosVersion { IosVersion(major: 11) }
        public static var iOS12: IosVersion { IosVersion(major: 12) }
        public static var iOS12_1: IosVersion { IosVersion(major: 12, minor: 1) }
        public static var iOS13: IosVersion { IosVersion(major: 13) }
        
        public static var all: [IosVersion] {
            [
                iOS10,
                iOS11,
                iOS12,
                iOS13
            ]
        }
    }
    
    // For code that checks boundaries, for example
    public final class Future {
        public static var iOS17: IosVersion { IosVersion(major: 17) }
    }
}

#endif
