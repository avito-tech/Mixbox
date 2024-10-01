#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxUiKit

struct KeyboardWindowExposerPrecondition {
    // This is to not to pass a lot of args to static functions
    let sourceWindows: [UIWindow]
    let keyboardPrivateApi: KeyboardPrivateApi
    let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    let iosVersionProvider: IosVersionProvider
    let accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    
    // These are calculated properties
    let uiTextEffectsWindow: UIWindow
    let publicUiRemoteKeyboardWindow: UIWindow? // Not present on iOS 16
    let privateUiRemoteKeyboardWindow: UIWindow
    let privateUiRemoteKeyboardWindowInputSetHostView: UIView
    let keyboardLayout: KeyboardLayout
    
    let uiTextEffectsWindowClass: AnyClass
    let uiRemoteKeyboardWindowClass: AnyClass
    let uiInputSetHostViewClass: AnyClass
}

#endif
