import Dip

// TODO: SRP.
open class BaseDi: Di {
    private let container = DependencyContainer()
    
    // MARK: - Di
    
    public final func bootstrap(overrides: (DependencyContainer) -> ()) throws {
        registerAll(container: container)
        
        overrides(container)
        
        try container.bootstrap()
    }
    
    public final func resolve<T>() throws -> T {
        return try container.resolve()
    }
    
    // MARK: - Registration
    
    // Call super, please. Do not call outside of subclasses (think of it as a protected member).
    open func registerAll(container: DependencyContainer) {
    }
    
    // MARK: - Validation
    
    public final func validate() throws {
        try container.validate()
    }
}
