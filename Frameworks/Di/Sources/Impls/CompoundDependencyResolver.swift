import MixboxDi
import MixboxFoundation

public final class CompoundDependencyResolver: DependencyResolver {
    private let resolvers: [DependencyResolver]
    
    public init(resolvers: [DependencyResolver]) {
        self.resolvers = resolvers
    }
    
    public func resolve<T>() throws -> T {
        var errors = [Error]()
        for resolver in resolvers {
            do {
                return try resolver.resolve()
            } catch {
                errors.append(error)
            }
        }
        
        let errorsJoined = errors.map { String(describing: $0) }.joined(separator: ", ")
        
        throw ErrorString("Failed to resolve \(T.self): \(errorsJoined)")
    }
}
