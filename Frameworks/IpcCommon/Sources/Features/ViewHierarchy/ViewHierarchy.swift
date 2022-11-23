#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxFoundation

public final class ViewHierarchy: Codable, CustomDebugStringConvertible {
    public let rootElements: [ViewHierarchyElement]
    
    public init(rootElements: [ViewHierarchyElement]) {
        self.rootElements = rootElements
    }
    
    public var debugDescription: String {
        return rootElements
            .map { $0.debugDescription }
            .joined(separator: ",\n")
            .mb_wrapAndIndent(
                prefix: "{",
                postfix: "}"
            )
    }
}

#endif
