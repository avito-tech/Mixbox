import MixboxInAppServices

final class TestingViewControllerSettings {
    let viewType: String
    let mixboxInAppServices: MixboxInAppServices?
    
    init(
        viewType: String,
        mixboxInAppServices: MixboxInAppServices?)
    {
        self.viewType = viewType
        self.mixboxInAppServices = mixboxInAppServices
    }
}

extension TestingViewControllerSettings {
    var viewIpc: ViewIpc {
        return ViewIpc(ipcMethodHandlerWithDependenciesRegisterer: mixboxInAppServices)
    }
}
