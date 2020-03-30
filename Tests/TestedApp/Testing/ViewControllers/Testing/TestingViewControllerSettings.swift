import MixboxInAppServices

final class TestingViewControllerSettings {
    let viewType: String
    let mixboxInAppServices: MixboxInAppServices?
    let navigationController: UINavigationController
    
    init(
        viewType: String,
        mixboxInAppServices: MixboxInAppServices?,
        navigationController: UINavigationController)
    {
        self.viewType = viewType
        self.mixboxInAppServices = mixboxInAppServices
        self.navigationController = navigationController
    }
}

extension TestingViewControllerSettings {
    var viewIpc: ViewIpc {
        return ViewIpc(ipcMethodHandlerWithDependenciesRegisterer: mixboxInAppServices)
    }
}
