#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxIpcCommon

public final class ExposedKeyboard {
    public let keyboardDrawingModeFactory: () throws -> (KeyboardDrawingMode)
    public let patchedElementHierarchyFactory: () throws -> ([ViewHierarchyElement])
    
    public init(
        keyboardDrawingModeFactory: @escaping () throws -> (KeyboardDrawingMode),
        patchedElementHierarchyFactory: @escaping () throws -> ([ViewHierarchyElement])
    ) {
        self.keyboardDrawingModeFactory = keyboardDrawingModeFactory
        self.patchedElementHierarchyFactory = patchedElementHierarchyFactory
    }
    
    public func keyboardDrawingMode() throws -> KeyboardDrawingMode {
        return try keyboardDrawingModeFactory()
    }
    
    public func patchedElementHierarchy() throws -> [ViewHierarchyElement] {
        return try patchedElementHierarchyFactory()
    }
}

#endif
