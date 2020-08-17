import MixboxDi
import MixboxBuiltinDi
import XCTest

final class BuiltinDependencyInjectionTests: TestCase {
    let dependencyInjectionFactory: DependencyInjectionFactory = BuiltinDependencyInjectionFactory()
    
    func test___resolve___resolves_lastly_registered_dependency() {
        assertDoesntThrow {
            let di = dependencyInjectionFactory.dependencyInjection()
            
            di.register(type: Int.self) { _ in 1 }
            di.register(type: Int.self) { _ in 2 }
            
            XCTAssertEqual(2, try di.resolve())
        }
    }
    
    func test___resolve___can_resolve_recursively() {
        assertDoesntThrow {
            struct Container {
                let value: Int
            }
            
            let di = dependencyInjectionFactory.dependencyInjection()
            
            di.register(type: Int.self) { _ in 1 }
            di.register(type: Container.self) { di in
                Container(
                    value: try di.resolve()
                )
            }
            
            XCTAssertEqual(
                (try di.resolve() as Container).value,
                1
            )
        }
    }
    
    func test___resolve___uses_nestedDependencyResolver_passed_as_an_argument() {
        assertDoesntThrow {
            struct Container {
                let value: Int
            }
            
            let di0 = dependencyInjectionFactory.dependencyInjection()
            let di1 = dependencyInjectionFactory.dependencyInjection()
            
            di0.register(type: Int.self) { _ in 0 }
            di1.register(type: Int.self) { _ in 1 }
            di1.register(type: Container.self) { di in
                Container(
                    value: try di.resolve()
                )
            }
            
            XCTAssertEqual(
                (try di1.resolve(nestedDependencyResolver: di0) as Container).value,
                0
            )
        }
    }
    
    func test___resolve___can_resolve_dependency_as_optional___if_type_was_registered_as_non_optional() {
        assertDoesntThrow {
            let di = dependencyInjectionFactory.dependencyInjection()
            
            di.register(type: Int.self) { _ in 1 }
            
            XCTAssertEqual(
                try di.resolve() as Int?,
                1
            )
        }
    }
    
    // This test checks that factories for Optional<T> are not overwritten with factories for T.
    func test___resolve___respects_optionality_in_registration() {
        assert___resolve___respects_optionality_in_registration(registrationOrderIsReversed: true)
        assert___resolve___respects_optionality_in_registration(registrationOrderIsReversed: false)
    }
    
    func assert___resolve___respects_optionality_in_registration(registrationOrderIsReversed: Bool) {
        var registerCalls: [(DependencyRegisterer) -> ()] = [
        { $0.register(type: Int.self) { _ in 1 } },
        { $0.register(type: Int?.self) { _ in 2 } }
        ]
        
        assertDoesntThrow {
            let di = dependencyInjectionFactory.dependencyInjection()
            
            if registrationOrderIsReversed {
                registerCalls = Array(registerCalls.reversed())
            }
            
            for call in registerCalls {
                call(di)
            }
            
            XCTAssertEqual(
                try di.resolve() as Int,
                1
            )
            XCTAssertEqual(
                try di.resolve() as Int?,
                2
            )
        }
    }
    
    func test___register___doesnt_cause_retain_cycle___when_dependency_resolver_is_passed_to_a_factory() {
        weak var weakDi: DependencyInjection?
        
        assertDoesntThrow {
            let di = dependencyInjectionFactory.dependencyInjection()
            
            weakDi = di
            
            di.register(type: Double.self) { _ in 1 }
            di.register(type: Int.self) { di in
                Int(try di.resolve() as Double)
            }
            
            // Little self-check of the test
            XCTAssertEqual(1, try di.resolve())
            XCTAssertNotNil(weakDi)
        }
        
        XCTAssertNil(weakDi)
    }
    
    // This is expected behavior. If you want to avoidd retain cycle, wrap `dependencyResolver` with `WeakDependencyResolver` manually.
    func test___register___doesnt_cause_retain_cycle___when_dependency_resolver_is_passed_to_a_singleton_and_WeakDependencyResolver_is_used() {
        weak var weakDi: DependencyInjection?
        
        assertDoesntThrow {
            let di = dependencyInjectionFactory.dependencyInjection()
            
            weakDi = di
            
            di.register(type: DependencyResolverHolder.self) { di in
                DependencyResolverHolder(
                    dependencyResolver: WeakDependencyResolver(
                        dependencyResolver: di
                    )
                )
            }
            
            _ = try di.resolve() as DependencyResolverHolder
        }
        
        XCTAssertNil(weakDi)
    }
    
    // This is expected behavior. If you want to avoidd retain cycle, wrap `dependencyResolver` with `WeakDependencyResolver` manually.
    func test___register___causes_retain_cycle___when_dependency_resolver_is_passed_to_a_singleton_and_WeakDependencyResolver_is_not_used() {
        weak var weakDi: DependencyInjection?
        
        assertDoesntThrow {
            let di = dependencyInjectionFactory.dependencyInjection()
            
            weakDi = di
            
            di.register(type: DependencyResolverHolder.self) { di in
                DependencyResolverHolder(
                    dependencyResolver: di
                )
            }
            
            _ = try di.resolve() as DependencyResolverHolder
        }
        
        XCTAssertNotNil(weakDi)
    }
    
    // See `DependencyRegisterer+RegisterMultiple.swift` for explanation
    func check___reregister() {
        // `bobRegistrationScope` doesn't matter.
        iterateCombinations { aliceRegistrationScope, aliceReregistrationScope, bobRegistrationScope, shouldResolve in
            let willBeRegisteredAsSingle = aliceRegistrationScope == .single
                || aliceReregistrationScope == .single
            
            let valueWillBeCached = shouldResolve && willBeRegisteredAsSingle
            
            check___reregister(
                registerColleague: Alice.self,
                as: aliceRegistrationScope,
                reregisterAs: aliceReregistrationScope,
                resolveColleague: shouldResolve,
                thenRegisterColleague: Bob.self,
                as: bobRegistrationScope,
                expectedTypeOfColleagueAfterResolve: valueWillBeCached
                    ? Alice.self
                    : Bob.self
            )
        }
    }
    
    private func iterateCombinations(body: (Scope, Scope, Scope, Bool) -> ()) {
        for x in Scope.allCases {
            for y in Scope.allCases {
                for z in Scope.allCases {
                    for w in [false, true] {
                        body(x, y, z, w)
                    }
                }
            }
        }
    }
    
    private func check___reregister<T1: Colleague, T2: Colleague, TE: Colleague>(
        registerColleague: T1.Type,
        as registerScope: Scope,
        reregisterAs reregisterScope: Scope,
        resolveColleague: Bool,
        thenRegisterColleague: T2.Type,
        as secondRegistrationScope: Scope,
        expectedTypeOfColleagueAfterResolve: TE.Type)
    {
        assertDoesntThrow {
            let di = dependencyInjectionFactory.dependencyInjection()
            
            di.registerMultiple(scope: registerScope, type: Colleague.self) { _ in T1() }
                .reregister(scope: reregisterScope) { $0 as Employee }
            
            if resolveColleague {
                XCTAssert((try di.resolve() as Colleague) is T1)
                XCTAssert((try di.resolve() as Employee) is T1)
            }
            
            di.register(scope: secondRegistrationScope, type: Colleague.self) { _ in T2() }
            
            let resolvedInstance = try di.resolve() as Employee
            
            XCTAssert(
                resolvedInstance is TE,
                """
                Resolved instance is of type \(type(of: resolvedInstance)), \
                expected: \(expectedTypeOfColleagueAfterResolve), \
                registerColleague: \(registerColleague),
                registerScope: \(registerScope),: Scope,
                reregisterScope: \(reregisterScope),
                resolveColleague: \(resolveColleague),
                thenRegisterColleague: \(thenRegisterColleague),
                secondRegistrationScope: \(secondRegistrationScope)
                """
            )
            
            XCTAssert((try di.resolve() as Colleague) is T2)
        }
    }
}

private extension Scope {
    static var allCases: [Scope] {
        return [.single, .unique]
    }
}

// To check reregister.
private protocol Employee {
    init()
}
private class Colleague: Employee {
    required init() {}
}
private final class Alice: Colleague {
    required init() {}
}
private final class Bob: Colleague {
    required init() {}
}

// To check retain cycles
private class DependencyResolverHolder {
    let dependencyResolver: DependencyResolver
    
    init(dependencyResolver: DependencyResolver) {
        self.dependencyResolver = dependencyResolver
    }
}
