public protocol ApplicationStateProvider: class {
    func applicationState() throws -> ApplicationState
}
