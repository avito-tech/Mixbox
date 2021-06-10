#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class StartedInAppServices {
    public let startedIpc: StartedIpc
    
    public init(
        startedIpc: StartedIpc)
    {
        self.startedIpc = startedIpc
    }
}

#endif
