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
}

private struct Container {
    let value: Int
}
