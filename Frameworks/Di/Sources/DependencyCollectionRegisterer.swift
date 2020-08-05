#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol DependencyCollectionRegisterer {
    func register(dependencyRegisterer: DependencyRegisterer)
}

#endif
