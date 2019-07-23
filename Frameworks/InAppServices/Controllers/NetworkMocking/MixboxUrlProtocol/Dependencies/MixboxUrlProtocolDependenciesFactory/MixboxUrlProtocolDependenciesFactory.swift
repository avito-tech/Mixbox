#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol MixboxUrlProtocolDependenciesFactory: class {
    func mixboxUrlProtocolClassDependencies() -> MixboxUrlProtocolDependencies
}

#endif
