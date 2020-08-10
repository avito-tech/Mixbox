import MixboxDi
import MixboxTestsFoundation

class BaseDependencyInjectionTests: TestCase {
    var dependencyInjectionFactory: DependencyInjectionFactory {
        UnavoidableFailure.fail("`dependencyInjectionFactory` is not implemented in \(type(of: self))")
    }
    
    func check___resolve___resolves_lastly_registered_dependency() {
        assertDoesntThrow {
            let di = dependencyInjectionFactory.dependencyInjection()
            
            di.register(type: Int.self) { _ in 1 }
            di.register(type: Int.self) { _ in 2 }
            
            XCTAssertEqual(2, try di.resolve())
        }
    }
    
    func check___resolve___can_resolve_recursively() {
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
    
    func check___resolve___can_resolve_dependency_as_optional___if_type_was_registered_as_non_optional() {
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
    func check___resolve___respects_optionality_in_registration() {
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
    
    func check___register___doesnt_cause_retain_cycle() {
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
