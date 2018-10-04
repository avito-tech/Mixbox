public protocol IpcRouter: class {
    func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler)
}
