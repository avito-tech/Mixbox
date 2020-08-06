import MixboxInAppServices

public final class TestingViewControllerSettings {
    public let viewType: String
    public let ipcMethodHandlerWithDependenciesRegisterer: IpcMethodHandlerWithDependenciesRegisterer?
    public let navigationController: UINavigationController?
    
    public init(
        viewType: String,
        ipcMethodHandlerWithDependenciesRegisterer: IpcMethodHandlerWithDependenciesRegisterer?,
        navigationController: UINavigationController?)
    {
        self.viewType = viewType
        self.ipcMethodHandlerWithDependenciesRegisterer = ipcMethodHandlerWithDependenciesRegisterer
        self.navigationController = navigationController
    }
}

extension TestingViewControllerSettings {
    public var viewIpc: ViewIpc {
        return ViewIpc(ipcMethodHandlerWithDependenciesRegisterer: ipcMethodHandlerWithDependenciesRegisterer)
    }
}
