#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol MixboxUrlProtocolDependenciesFactory: AnyObject {
    func mixboxUrlProtocolClassDependencies() -> MixboxUrlProtocolDependencies
}

#endif
