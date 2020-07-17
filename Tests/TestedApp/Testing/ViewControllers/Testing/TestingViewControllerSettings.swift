import MixboxInAppServices

public final class TestingViewControllerSettings {
    public let viewType: String
    public let mixboxInAppServices: MixboxInAppServices?
    public let navigationController: UINavigationController?
    
    public init(
        viewType: String,
        mixboxInAppServices: MixboxInAppServices?,
        navigationController: UINavigationController?)
    {
        self.viewType = viewType
        self.mixboxInAppServices = mixboxInAppServices
        self.navigationController = navigationController
    }
}

extension TestingViewControllerSettings {
    public var viewIpc: ViewIpc {
        return ViewIpc(ipcMethodHandlerWithDependenciesRegisterer: mixboxInAppServices)
    }
}
