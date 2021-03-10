import MixboxUiTestsFoundation
import MixboxInAppServices

public final class GrayElementHierarchyDescriptionProvider: ElementHierarchyDescriptionProvider {
    private let viewHierarchyProvider: ViewHierarchyProvider
    
    public init(
        viewHierarchyProvider: ViewHierarchyProvider)
    {
        self.viewHierarchyProvider = viewHierarchyProvider
    }
    
    public func elementHierarchyDescription() -> String? {
        // Note: debugDescription suits exactly same purpose as GrayElementHierarchyDescriptionProvider
        return viewHierarchyProvider.viewHierarchy().debugDescription
    }
}
