import MixboxUiTestsFoundation

public final class XcuiElementHierarchyDescriptionProvider: ElementHierarchyDescriptionProvider {
    private let applicationProvider: ApplicationProvider
    
    public init(
        applicationProvider: ApplicationProvider)
    {
        self.applicationProvider = applicationProvider
    }
    
    public func elementHierarchyDescription() -> String? {
        let application = applicationProvider.application
        return application.exists ? application.debugDescription : nil
    }
}
