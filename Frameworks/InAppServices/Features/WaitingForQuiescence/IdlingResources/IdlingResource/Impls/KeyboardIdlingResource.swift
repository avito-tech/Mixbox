#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class KeyboardIdlingResource: IdlingResource {
    private var observers = [NSObjectProtocol]()
    private var idle = true
    
    public init() {
        subscribeToNotifications()
    }
    
    public func isIdle() -> Bool {
        return idle
    }
    
    private func subscribeToNotifications() {
        let keyboardWillShowNotificationObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] _ in
            self?.idle = false
        }
        
        let keyboardDidShowNotificationObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil) { [weak self] _ in
            self?.idle = true
        }
        
        let keyboardWillHideNotificationObservcer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] _ in
            self?.idle = false
        }

        let keyboardDidHideNotificationObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil) { [weak self] _ in
            self?.idle = true
        }
        
        observers.append(contentsOf: [
            keyboardWillShowNotificationObserver,
            keyboardDidShowNotificationObserver,
            keyboardWillHideNotificationObservcer,
            keyboardDidHideNotificationObserver
        ])
    }
    
    deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

#endif
