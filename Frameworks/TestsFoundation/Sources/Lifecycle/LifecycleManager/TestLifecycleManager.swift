public protocol TestLifecycleManager: AnyObject {
    func startObserving(testLifecycleObservable: TestLifecycleObservable)
}
