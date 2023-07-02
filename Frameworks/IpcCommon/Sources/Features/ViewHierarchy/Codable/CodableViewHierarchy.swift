#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxFoundation

public final class CodableViewHierarchy: ViewHierarchy, Codable {
    public let codableRootElements: [CodableViewHierarchyElement]
    
    public init(codableRootElements: [CodableViewHierarchyElement]) {
        self.codableRootElements = codableRootElements
    }
    
    public convenience init(viewHierarchy: ViewHierarchy) {
        self.init(
            codableRootElements: viewHierarchy.rootElements.map {
                CodableViewHierarchyElement(
                    viewHierarchyElement: $0
                )
            }
        )
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case codableRootElements = "rootElements"
    }
    
    // MARK: - ViewHierarchy
    
    public var rootElements: RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        return RandomAccessCollectionOf(codableRootElements)
    }
}

#endif
