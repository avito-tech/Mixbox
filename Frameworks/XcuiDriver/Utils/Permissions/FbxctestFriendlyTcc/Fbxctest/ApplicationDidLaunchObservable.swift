import MixboxFoundation

public protocol ApplicationDidLaunchObservable {
    func addObserver(_ observer: ApplicationDidLaunchObserver)
}

public protocol ApplicationDidLaunchObserver: class {
    func applicationDidLaunch()
}

// Stupid implementation of observable, use carefully.
public final class ApplicationDidLaunchObservableImpl: ApplicationDidLaunchObservable, ApplicationDidLaunchObserver {
    private var observers = [WeakApplicationDidLaunchObserverBox]()
    
    public init() {
    }
    
    public func addObserver(_ observer: ApplicationDidLaunchObserver) {
        observers.append(
            WeakApplicationDidLaunchObserverBox(
                applicationDidLaunchObserver: observer
            )
        )
    }
    
    public func applicationDidLaunch() {
        observers.forEach {
            $0.applicationDidLaunchObserver?.applicationDidLaunch()
        }
    }
}

private class WeakApplicationDidLaunchObserverBox {
    weak var applicationDidLaunchObserver: ApplicationDidLaunchObserver?
    
    init(applicationDidLaunchObserver: ApplicationDidLaunchObserver) {
        self.applicationDidLaunchObserver = applicationDidLaunchObserver
    }
}
