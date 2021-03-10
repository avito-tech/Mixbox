public protocol ApplicationLifecycleObserver: class {
    func applicationStateChanged(applicationIsLaunched: Bool)
}
