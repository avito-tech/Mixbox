#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxUiKit
import MixboxFoundation

final class KeyboardWindowExposerPreconditionValidator {
    private let keyboardPrivateApi: KeyboardPrivateApi
    private let iosVersionProvider: IosVersionProvider
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    private let accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    
    init(
        keyboardPrivateApi: KeyboardPrivateApi,
        iosVersionProvider: IosVersionProvider,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher,
        accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    ) {
        self.keyboardPrivateApi = keyboardPrivateApi
        self.iosVersionProvider = iosVersionProvider
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
        self.accessibilityUniqueObjectMap = accessibilityUniqueObjectMap
    }
    
    func validatePreconditionForExposure(
        windows: [UIWindow]
    ) throws -> KeyboardWindowExposerPreconditionValidatorResult {
        let uiTextEffectsWindowClass: AnyClass = try objcClassFromString("UITextEffectsWindow")
        let uiRemoteKeyboardWindowClass: AnyClass = try objcClassFromString("UIRemoteKeyboardWindow")
        let uiInputSetHostViewClass: AnyClass = try objcClassFromString("UIInputSetHostView")
        
        guard let keyboardLayout = keyboardPrivateApi.layout() else {
            return .shouldReturnResult(.keyboardIsNotVisible(description: "No keyboard layout"))
        }
        
        guard let windowWithScreensBounds = windows.first else {
            throw ErrorString("Did not get any application window")
        }
        
        // This can happen when keyboard is just closed.
        // Layout is not nil for some reason. The `privateKeyboardWindow` appears to be empty
        // in debugger, however, if drawn, the whole screenshot will look buggy/messy,
        // there will be a part of keyboard layout drawn on top (!) of the screen.
        if Self.keyboardIsHidden(keyboardPrivateApi: keyboardPrivateApi, windowWithScreensBounds: windowWithScreensBounds) {
            return .shouldReturnResult(.keyboardIsNotVisible(description: "Keyboard is not visible"))
        }
        
        guard let uiTextEffectsWindow = windows.first(where: { $0.isKind(of: uiTextEffectsWindowClass) }) else {
            return .shouldReturnResult(.keyboardIsNotVisible(description: "Did not get \(uiTextEffectsWindowClass)"))
        }
        
        let publicUiRemoteKeyboardWindow = windows.first(where: { $0.isKind(of: uiRemoteKeyboardWindowClass) })
        
        let privateKeyboardViews = try findPrivateKeyboardViews(
            uiInputSetHostViewClass: uiInputSetHostViewClass,
            uiRemoteKeyboardWindowClass: uiRemoteKeyboardWindowClass,
            keyboardLayout: keyboardLayout
        )
        
        return .shouldContinue(
            KeyboardWindowExposerPrecondition(
                sourceWindows: windows,
                keyboardPrivateApi: keyboardPrivateApi,
                floatValuesForSr5346Patcher: floatValuesForSr5346Patcher,
                iosVersionProvider: iosVersionProvider,
                accessibilityUniqueObjectMap: accessibilityUniqueObjectMap,
                
                uiTextEffectsWindow: uiTextEffectsWindow,
                publicUiRemoteKeyboardWindow: publicUiRemoteKeyboardWindow,
                privateUiRemoteKeyboardWindow: privateKeyboardViews.privateUiRemoteKeyboardWindow,
                privateUiRemoteKeyboardWindowInputSetHostView: privateKeyboardViews.privateUiRemoteKeyboardWindowInputSetHostView,
                keyboardLayout: keyboardLayout,
                
                uiTextEffectsWindowClass: uiTextEffectsWindowClass,
                uiRemoteKeyboardWindowClass: uiRemoteKeyboardWindowClass,
                uiInputSetHostViewClass: uiInputSetHostViewClass
            )
        )
    }
    
    private struct PrivateKeyboardViews {
        let privateUiRemoteKeyboardWindow: UIWindow
        let privateUiRemoteKeyboardWindowInputSetHostView: UIView
    }
    
    private func findPrivateKeyboardViews(
        uiInputSetHostViewClass: AnyClass,
        uiRemoteKeyboardWindowClass: AnyClass,
        keyboardLayout: KeyboardLayout
    ) throws -> PrivateKeyboardViews {
        var uiInputSetHostViewOrNil: UIView?
        
        var viewPointer: UIView = keyboardLayout.underlyingObject
        while let superview = viewPointer.superview {
            if viewPointer.isKind(of: uiInputSetHostViewClass) {
                uiInputSetHostViewOrNil = viewPointer
            }
            
            viewPointer = superview
        }
        
        guard let privateUiRemoteKeyboardWindow = viewPointer as? UIWindow else {
            throw ErrorString("Keyboard layout's top superview is not a UIWindow")
        }
        
        guard privateUiRemoteKeyboardWindow.isKind(of: uiRemoteKeyboardWindowClass) else {
            throw ErrorString("Keyboard layout's top superview is not a \(uiRemoteKeyboardWindowClass)")
        }
        
        guard let privateUiRemoteKeyboardWindowInputSetHostView = uiInputSetHostViewOrNil else {
            throw ErrorString("Couldn't find \(uiInputSetHostViewClass) in keyboard hierarchy")
        }
        
        return PrivateKeyboardViews(
            privateUiRemoteKeyboardWindow: privateUiRemoteKeyboardWindow,
            privateUiRemoteKeyboardWindowInputSetHostView: privateUiRemoteKeyboardWindowInputSetHostView
        )
    }
    
    private func objcClassFromString(_ string: String) throws -> AnyClass {
        guard let anyClass = NSClassFromString(string) else {
            throw ErrorString(
                """
                Failed to get NSClassFromString(\(string.debugDescription))
                """
            )
        }
        
        return anyClass
    }
    
    private static func keyboardIsHidden(
        keyboardPrivateApi: KeyboardPrivateApi,
        windowWithScreensBounds: UIWindow
    ) -> Bool {
        let frameOfMainWindowNotOverlappedByKeyboard = keyboardPrivateApi.subtractKeyboardFrame(
            rect: windowWithScreensBounds.bounds,
            view: windowWithScreensBounds
        )
        
        return frameOfMainWindowNotOverlappedByKeyboard == windowWithScreensBounds.bounds
    }
}

#endif
