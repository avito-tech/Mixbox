#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol IpcRouter: AnyObject {
    func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler)
}

#endif
