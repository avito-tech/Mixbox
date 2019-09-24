public final class CachingEmceeProvider: EmceeProvider {
    private let emceeProvider: EmceeProvider
    private var cachedEmcee: Emcee?
    
    public init(emceeProvider: EmceeProvider) {
        self.emceeProvider = emceeProvider
    }
    
    public func emcee() throws -> Emcee {
        if let cachedEmcee = cachedEmcee {
            return cachedEmcee
        } else {
            let emcee = try emceeProvider.emcee()
            
            cachedEmcee = emcee
            
            return emcee
        }
    }
}
