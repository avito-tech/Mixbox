#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol IpcRouter: class {
    func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler)
}

#endif
