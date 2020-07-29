#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class StartedInAppServices {
    public let router: IpcRouter
    public let client: IpcClient?
    
    public init(
        router: IpcRouter,
        client: IpcClient?)
    {
        self.router = router
        self.client = client
    }
}

#endif
