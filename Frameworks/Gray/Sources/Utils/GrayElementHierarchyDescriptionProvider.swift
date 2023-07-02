import MixboxUiTestsFoundation
import MixboxIpcCommon

public final class GrayElementHierarchyDescriptionProvider: ElementHierarchyDescriptionProvider {
    private let viewHierarchyProvider: ViewHierarchyProvider
    
    public init(
        viewHierarchyProvider: ViewHierarchyProvider
    ) {
        self.viewHierarchyProvider = viewHierarchyProvider
    }
    
    public func elementHierarchyDescription() -> String? {
        // TODO: Handle errors?
        return try? viewHierarchyProvider.viewHierarchy().debugDescription
    }
}
