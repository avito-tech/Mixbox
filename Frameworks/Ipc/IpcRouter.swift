public protocol IpcRouter {
    func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler)
}
