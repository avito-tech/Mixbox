#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

class ThreadLocalObject<T> {
    private let key: String
    private var valueToBeSetAtGet: T?
    
    init(key: String, initialValue: T) {
        self.key = key
        self.valueToBeSetAtGet = initialValue
    }
    
    var value: T? {
        get {
            if let value = Thread.current.threadDictionary[key] as? T {
                return value
            } else {
                let value = valueToBeSetAtGet
                valueToBeSetAtGet = nil
                Thread.current.threadDictionary[key] = value
                return value
            }
        }
        set {
            Thread.current.threadDictionary[key] = newValue
        }
    }
}

#endif
