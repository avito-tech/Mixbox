public protocol ApplicationLifecycleObservable: class {
    var applicationIsLaunched: Bool { get }
    func addObserver(_ observer: ApplicationLifecycleObserver)
}
