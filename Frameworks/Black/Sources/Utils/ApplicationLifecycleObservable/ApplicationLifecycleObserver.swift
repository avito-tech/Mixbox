public protocol ApplicationLifecycleObserver: AnyObject {
    func applicationStateChanged(applicationIsLaunched: Bool)
}
