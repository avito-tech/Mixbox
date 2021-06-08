public protocol ApplicationStateProvider: AnyObject {
    func applicationState() throws -> ApplicationState
}
