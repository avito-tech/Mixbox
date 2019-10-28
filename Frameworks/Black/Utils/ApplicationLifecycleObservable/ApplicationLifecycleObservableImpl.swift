import MixboxFoundation

// Stupid implementation of observable, use carefully.
public final class ApplicationLifecycleObservableImpl: ApplicationLifecycleObservable, ApplicationLifecycleObserver {
    private var observers = [WeakApplicationLifecycleObserverBox]()
    public private(set) var applicationIsLaunched: Bool = false
    
    public init() {
    }
    
    public func addObserver(_ observer: ApplicationLifecycleObserver) {
        observers.append(
            WeakApplicationLifecycleObserverBox(
                applicationLifecycleObserver: observer
            )
        )
    }
    
    public func applicationStateChanged(applicationIsLaunched: Bool) {
        self.applicationIsLaunched = applicationIsLaunched
        
        observers.forEach {
            $0.applicationLifecycleObserver?.applicationStateChanged(applicationIsLaunched: applicationIsLaunched)
        }
    }
}

private class WeakApplicationLifecycleObserverBox {
    weak var applicationLifecycleObserver: ApplicationLifecycleObserver?
    
    init(applicationLifecycleObserver: ApplicationLifecycleObserver) {
        self.applicationLifecycleObserver = applicationLifecycleObserver
    }
}
