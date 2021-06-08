public protocol ApplicationLifecycleObservable: AnyObject {
    var applicationIsLaunched: Bool { get }
    func addObserver(_ observer: ApplicationLifecycleObserver)
}
