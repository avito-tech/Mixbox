#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol EnvironmentProvider: class {
    var environment: [String: String] { get }
}

#endif
