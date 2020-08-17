import MixboxDi
import MixboxBuiltinDi
import MixboxTestsFoundation

class CompoundDependencyResolverTests: TestCase {
    private let dependencyInjectionFactory = BuiltinDependencyInjectionFactory()
    
    func test() {
        let aDi = dependencyInjectionFactory.dependencyInjection()
        let bDi = dependencyInjectionFactory.dependencyInjection()
        
        aDi.register(type: A.self) { di in
            A(try di.resolve())
        }
        bDi.register(type: B.self) { _ in
            B()
        }
        
        let di = CompoundDependencyResolver(
            resolvers: [aDi, bDi]
        )
        
        assertDoesntThrow {
            _ = try di.resolve() as A
            _ = try di.resolve() as B
        }
    }
}

private class A {
    init(_: B){}
}
private class B {
    init(){}
}
