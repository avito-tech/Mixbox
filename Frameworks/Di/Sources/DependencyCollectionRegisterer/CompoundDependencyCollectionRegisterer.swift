#if MIXBOX_ENABLE_FRAMEWORK_DI && MIXBOX_DISABLE_FRAMEWORK_DI
#error("Di is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_DI || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_DI)
// The compilation is disabled
#else

public final class CompoundDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    private let registerers: [DependencyCollectionRegisterer]
    
    public init(registerers: [DependencyCollectionRegisterer]) {
        self.registerers = registerers
    }
    
    public func register(dependencyRegisterer: DependencyRegisterer) {
        registerers.forEach {
            $0.register(dependencyRegisterer: dependencyRegisterer)
        }
    }
}

#endif
