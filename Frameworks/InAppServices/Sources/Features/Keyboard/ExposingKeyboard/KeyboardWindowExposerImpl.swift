#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxUiKit
import MixboxIpcCommon
import MixboxFoundation
import MixboxTestability

public final class KeyboardWindowExposerImpl: KeyboardWindowExposer {
    private let keyboardWindowExposerPreconditionValidator: KeyboardWindowExposerPreconditionValidator
    
    public init(
        keyboardPrivateApi: KeyboardPrivateApi,
        iosVersionProvider: IosVersionProvider,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    ) {
        keyboardWindowExposerPreconditionValidator = KeyboardWindowExposerPreconditionValidator(
            keyboardPrivateApi: keyboardPrivateApi,
            iosVersionProvider: iosVersionProvider,
            floatValuesForSr5346Patcher: floatValuesForSr5346Patcher
        )
    }
    
    public func exposeKeyboardWindow(
        windows: [UIWindow]
    ) throws -> KeyboardWindowExposerResult {
        switch try keyboardWindowExposerPreconditionValidator.validatePreconditionForExposure(windows: windows) {
        case let .shouldReturnResult(result):
            return result
        case let .shouldContinue(precondition):
            return .exposedKeyboard(
                ExposedKeyboard(
                    keyboardDrawingModeFactory: {
                        try Self.keyboardDrawingMode(
                            precondition: precondition
                        )
                    },
                    patchedElementHierarchyFactory: {
                        try Self.patchedElementHierarchy(
                            precondition: precondition
                        )
                    }
                )
            )
        }
    }
    
    private static func patchedElementHierarchy(
        precondition: KeyboardWindowExposerPrecondition
    ) throws -> [ViewHierarchyElement] {
        try patchedWindows(
            precondition: precondition,
            shouldThrowErrorIfPublicUiRemoteKeyboardWindowIsPresentInHierarchy: false
        ).map { window -> ViewHierarchyElement in
            if window === precondition.privateUiRemoteKeyboardWindow {
                return OverridingChildrenTestabilityElementViewHierarchyElement(
                    testabilityElement: window,
                    floatValuesForSr5346Patcher: precondition.floatValuesForSr5346Patcher,
                    overrideChild: { testabilityElement in
                        if testabilityElement === precondition.keyboardLayout {
                            return KeyboardLayoutViewHierarchyElement(
                                keyboardLayout: precondition.keyboardLayout,
                                floatValuesForSr5346Patcher: precondition.floatValuesForSr5346Patcher
                            )
                        } else {
                            return nil
                        }
                    }
                )
            } else {
                return TestabilityElementViewHierarchyElement(
                    testabilityElement: window,
                    floatValuesForSr5346Patcher: precondition.floatValuesForSr5346Patcher
                )
            }
        }
    }
    
    private static func keyboardDrawingMode(
        precondition: KeyboardWindowExposerPrecondition
    ) throws -> KeyboardDrawingMode {
        guard precondition.iosVersionProvider.iosVersion().majorVersion >= MixboxIosVersions.Supported.iOS16 else {
            // Everything is fine below iOS 16
            return .drawOriginalWindows
        }
        
        let exposedKeyboardWindows = ExposedKeyboardWindows(
            windowWithDrawableKeyboard: precondition.privateUiRemoteKeyboardWindow,
            windowWithDrawableAccessoryViews: precondition.uiTextEffectsWindow,
            patchedWindows: try patchedWindows(
                precondition: precondition,
                shouldThrowErrorIfPublicUiRemoteKeyboardWindowIsPresentInHierarchy: true
            )
        )
        
        return .drawPatchedWindows(exposedKeyboardWindows)
    }
    
    private static func patchedWindows(
        precondition: KeyboardWindowExposerPrecondition,
        shouldThrowErrorIfPublicUiRemoteKeyboardWindowIsPresentInHierarchy: Bool
    ) throws -> [UIWindow] {
        try precondition.sourceWindows.flatMap { (sourceWindow: UIWindow) -> [UIWindow] in
            if sourceWindow === precondition.uiTextEffectsWindow {
                return [
                    sourceWindow,
                    precondition.privateUiRemoteKeyboardWindow
                ]
            } else if sourceWindow === precondition.publicUiRemoteKeyboardWindow {
                if shouldThrowErrorIfPublicUiRemoteKeyboardWindowIsPresentInHierarchy {
                    throw ErrorString(
                        """
                        \(precondition.uiRemoteKeyboardWindowClass) was not expected to be present in view hierarchy
                        """
                    )
                }
                
                return []
            } else {
                return [sourceWindow]
            }
        }
    }
}

#endif
