#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol EnvironmentProvider: AnyObject {
    var environment: [String: String] { get }
}

#endif
