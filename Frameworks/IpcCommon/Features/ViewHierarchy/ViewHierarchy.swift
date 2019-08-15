#if MIXBOX_ENABLE_IN_APP_SERVICES

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
