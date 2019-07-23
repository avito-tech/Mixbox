import MixboxInAppServices

#if !DEBUG
import MixboxIpc
typealias MixboxInAppServices = IpcRouter
#endif

final class TestingViewControllerSettings {
    let name: String
    let mixboxInAppServices: MixboxInAppServices?
    
    init(
        name: String,
        mixboxInAppServices: MixboxInAppServices?)
    {
        self.name = name
        self.mixboxInAppServices = mixboxInAppServices
    }
}

extension TestingViewControllerSettings {
    var viewIpc: ViewIpc {
        return ViewIpc(ipcMethodHandlerWithDependenciesRegisterer: mixboxInAppServices)
    }
}
