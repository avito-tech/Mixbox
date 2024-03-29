#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class KeyboardIdlingResource: IdlingResource {
    private var observers = [NSObjectProtocol]()
    
    private var isShowing = false
    private var isHiding = false
    
    public init() {
        subscribeToNotifications()
    }
    
    public var resourceDescription: String {
        """
        KeyboardIdlingResource {
            isShowing: \(isShowing),
            isHiding: \(isHiding),
        }
        """
    }
    
    public func isIdle() -> Bool {
        return !isShowing && !isHiding
    }
    
    private func subscribeToNotifications() {
        let keyboardWillShowNotificationObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] _ in
            self?.isShowing = true
        }
        
        let keyboardDidShowNotificationObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil) { [weak self] _ in
            self?.isShowing = false
        }
        
        let keyboardWillHideNotificationObservcer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] _ in
            self?.isHiding = true
        }

        let keyboardDidHideNotificationObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil) { [weak self] _ in
            self?.isHiding = false
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
