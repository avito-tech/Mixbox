import MixboxDi
import MixboxBuiltinDi

final class BuiltinDependencyInjectionTests: BaseDependencyInjectionTests {
    override var dependencyInjectionFactory: DependencyInjectionFactory {
        return BuiltinDependencyInjectionFactory()
    }
    
    func test___resolve___resolves_lastly_registered_dependency() {
        check___resolve___resolves_lastly_registered_dependency()
    }
    
    func test___resolve___can_resolve_recursively() {
        check___resolve___can_resolve_recursively()
    }
    
    func test___resolve___can_resolve_dependency_as_optional___if_type_was_registered_as_non_optional() {
        check___resolve___can_resolve_dependency_as_optional___if_type_was_registered_as_non_optional()
    }
    
    func test___resolve___respects_optionality_in_registration() {
        check___resolve___respects_optionality_in_registration()
    }
    
    func test___register___doesnt_cause_retain_cycle() {
        check___register___doesnt_cause_retain_cycle()
    }
    
    func test___reregister() {
        check___reregister()
    }
}
