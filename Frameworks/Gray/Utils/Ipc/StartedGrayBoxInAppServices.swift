import MixboxIpc
import MixboxInAppServices

public final class StartedGrayBoxInAppServices {
    public let ipcClient: IpcClient
    public let ipcRouter: IpcRouter
    public let mixboxInAppServices: MixboxInAppServices
    
    public init(
        ipcClient: IpcClient,
        ipcRouter: IpcRouter,
        mixboxInAppServices: MixboxInAppServices)
    {
        self.ipcClient = ipcClient
        self.ipcRouter = ipcRouter
        self.mixboxInAppServices = mixboxInAppServices
    }
}
