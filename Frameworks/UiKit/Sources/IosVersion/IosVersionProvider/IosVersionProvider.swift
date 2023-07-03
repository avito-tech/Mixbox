#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

// Examples:
//
// if iosVersionProvider.iosVersion() <= 7 { // iOS 6, iOS 7, iOS 7.1 suits
//
// switch iosVersionProvider.iosVersion() {
// case 6: break // iOS 6 suits
// case 7..<9: break // iOS 7, iOS 8, iOS 8.1 suits
// case 9...10.1: break // iOS 9, iOS 10, iOS 10.1 suits
// default: break
// }
//
// NOTE: Use `MixboxIosVersions` instead of magic numbers. See docs inside that class.

public protocol IosVersionProvider {
    func iosVersion() -> IosVersion
}

#endif
