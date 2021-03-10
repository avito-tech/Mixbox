import MixboxDi

open class BaseTopLevelDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    // To be overriden.
    open func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return []
    }
    
    public final func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
    }
}
