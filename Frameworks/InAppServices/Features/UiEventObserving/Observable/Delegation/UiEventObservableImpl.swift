#if MIXBOX_ENABLE_IN_APP_SERVICES

// Multicasts `UiEventObserver` events
public final class UiEventObservableImpl: UiEventObservable, UiEventObserver {
    public init() {
    }
    
    // MARK: - UiEventObserver
    
    public func eventWasSent(event: UIEvent, window: UIWindow) {
        forEachObserver {
            $0.eventWasSent(event: event, window: window)
        }
    }
    
    // MARK: - UiEventObservable
    
    // There is no way to implement generic observable with protocol as a generic type in Swift.
    // But the code below can be copypasted to implement other observables.
    // Also it's a good idea to dedicate a class for just managing observers.
    // The class can be reused in any class that observes events.
    
    // Not copypasteable boilerplate:

    public typealias Observer = UiEventObserver
    
    // Copypasteable boilerplate:
    
    private struct ObserverBox: Hashable {
        weak var value: Observer?
        
        private let objectIdentifier: ObjectIdentifier
        
        init(value: Observer) {
            self.value = value
            self.objectIdentifier = ObjectIdentifier(value)
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(objectIdentifier)
        }

        static func ==(left: ObserverBox, right: ObserverBox) -> Bool {
            return left.objectIdentifier == right.objectIdentifier
        }
    }
    
    private var observers = Set<ObserverBox>()
    
    private func forEachObserver(body: (Observer) -> ()) {
        // Iterate all elements and remove deallocated ones
        
        observers = observers.filter { box in
            let isIncluded: Bool

            if let observer = box.value {
                body(observer)

                isIncluded = true
            } else {
                isIncluded = false
            }

            return isIncluded
        }
    }

    public func add(observer: Observer) {
        observers.insert(ObserverBox(value: observer))
    }

    public func remove(observer: Observer) {
        observers.remove(ObserverBox(value: observer))
    }
    
    public func contains(observer: Observer) -> Bool {
        observers.contains { box in
            if let unboxed = box.value {
                return unboxed === observer
            } else {
                return false
            }
        }
    }
}

#endif
