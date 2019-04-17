public protocol ApplicationLifecycleObservable {
    var applicationIsLaunched: Bool { get }
    func addObserver(_ observer: ApplicationLifecycleObserver)
}
