public final class MutableClosuresTestLifecycleTestBundleObserver: TestLifecycleTestBundleObserver {
    public var onStart: ((_ bundle: Bundle) -> ())?
    public var onStop: ((_ bundle: Bundle) -> ())?
    
    public init(
        onStart: ((_: Bundle) -> Void)? = nil,
        onStop: ((_: Bundle) -> Void)? = nil
    ) {
        self.onStart = onStart
        self.onStop = onStop
    }
    
    public func onStart(testBundle: Bundle) {
        onStart?(testBundle)
    }
    
    public func onStop(testBundle: Bundle) {
        onStop?(testBundle)
    }
}
