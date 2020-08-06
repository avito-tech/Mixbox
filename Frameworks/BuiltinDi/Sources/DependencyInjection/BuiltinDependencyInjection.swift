#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxDi

public final class BuiltinDependencyInjection: DependencyInjection {
    private var dependencies = [HashableType: RegisteredDependency]()
    private let recursiveLock = NSRecursiveLock()
    
    public init() {
    }
    
    // This function is optimized for the case when most resolves are occuring in a same thread.
    // For example, if something is resolved slowly the lock will be locked.
    // Alternative is to release lock before calling `factory()`, but this will be very
    // slow for the aforementioned case of accessing `DependencyInjection` primarily from same thread.
    public func resolve<T>() throws -> T {
        let instance: Any = try lock { () -> Any in
            let type = T.self
            let hashableType = HashableType(type: type)
            
            if let registeredDependency = dependencies[hashableType] {
                switch registeredDependency.scope {
                case .single:
                    if let instance = registeredDependency.instance {
                        return instance
                    } else {
                        let instance = try registeredDependency.factory()
                        
                        dependencies[hashableType] = RegisteredDependency(
                            scope: registeredDependency.scope,
                            factory: registeredDependency.factory,
                            instance: instance
                        )
                        
                        return instance
                    }
                case .unique:
                    return try registeredDependency.factory()
                }
            } else {
                throw ErrorString("\(T.self) was not registered in DI")
            }
        }
        
        if let typedInstance = instance as? T {
            return typedInstance
        } else {
            throw ErrorString(
                "Internal error. Expected to resolve \(T.self), but resolved \(type(of: instance))"
            )
        }
    }
    
    public func register<T>(
        scope: Scope,
        type: T.Type,
        factory: @escaping (DependencyResolver) throws -> T)
    {
        let hashableType = HashableType(type: T.self)
        let hashableTypeForOptional = HashableType(type: T?.self)
        
        let registeredDependency = prepareRegisteredDependency(scope: scope, factory: factory)
        let registeredDependencyForOptional = prepareRegisteredDependencyForOptional(scope: scope, type: T.self)
        
        lock {
            if dependencies[hashableTypeForOptional] == nil {
                dependencies[hashableTypeForOptional] = registeredDependencyForOptional
            }
            dependencies[hashableType] = registeredDependency
        }
    }
    
    private func prepareRegisteredDependency<T>(
        scope: Scope,
        factory: @escaping (DependencyResolver) throws -> T)
        -> RegisteredDependency
    {
        return RegisteredDependency(
            scope: scope,
            factory:  { [weak self] in
                guard let dependencyResolver = self else {
                    throw ErrorString("Internal error: dependencyContainer was deallocated, which is unexpected")
                }
                
                return try factory(dependencyResolver)
            },
            instance: nil
        )
    }
    
    // Dependencies can often be optional, example:
    //
    // ```
    // class AbstractSingleton {
    //     init(proxy: Proxy, factory: Factory, bean: Bean?)
    // }
    // ```
    //
    // And there is absolutely no need to torment a developer with a necessity of registering
    // both T and Optional<T> for every T.
    //
    private func prepareRegisteredDependencyForOptional<T>(
        scope: Scope,
        type: T.Type = T.self)
        -> RegisteredDependency
    {
        return RegisteredDependency(
            scope: scope,
            factory:  { [weak self] in
                guard let dependencyResolver = self else {
                    throw ErrorString("Internal error: dependencyContainer was deallocated, which is unexpected")
                }
                
                return try dependencyResolver.resolve() as T
            },
            instance: nil
        )
    }
    
    private func lock<T>(body: () throws -> T) throws -> T {
        recursiveLock.lock()
        
        do {
            let result = try body()
            
            recursiveLock.unlock()
            
            return result
        } catch {
            recursiveLock.unlock()
            
            throw error
        }
    }
    
    private func lock<T>(body: () -> T) -> T {
        recursiveLock.lock()
        
        let result = body()
            
        recursiveLock.unlock()
        
        return result
    }
}

#endif
