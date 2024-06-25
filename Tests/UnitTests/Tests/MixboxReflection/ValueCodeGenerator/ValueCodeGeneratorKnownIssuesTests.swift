import XCTest
import MixboxReflection

// This test documents known issues, some issues can be documented in other tests
final class ValueCodeGeneratorKnownIssuesTests: BaseValueCodeGeneratorTests {
    func test___generateCode___is_not_aware_of_field_types() {
        struct Struct {
            let value: Any
        }
        
        checkKnownIssue(
            Struct(
                value: Enum.no_associated_value
            ),
            // Because type of `value` is Any we can not infer type,
            // but `ValueCodeGenerator` thinks that it can be inferred and
            // generates invalid code. It can be fixed if reflection will know
            // structure of any given entity (example: know that type of `value` is `Any`)
            """
            Struct(
                value: .no_associated_value
            )
            """
        )
    }

    // It can be fixed if we manually handle every case or maybe find some
    // public or private function to bridge values from Objective-C to Swift.
    func test___generateCode___fails_to_handle_Objective_C_types_properly() {
        checkKnownIssueWithValueBridgedToObjectiveC(
            1,
            """
            __NSCFNumber()
            """
        )
    }
    
    func test___generateCode___generates_ambigous_code_when_class_names_from_different_namespaces_have_same_names() {
        class A {
            class C {}
        }
        class B {
            class C {}
        }
        
        checkKnownIssue(
            A.C(),
            """
            C()
            """
        )
        checkKnownIssue(
            B.C(),
            """
            C()
            """
        )
    }
    
    func test___generateCode___can_not_generate_enum_case_name_for_case_without_associated_value_if_type_is_not_enum() {
        struct NotEnum: CustomReflectable {
            var customMirror: Mirror {
                Mirror(
                    self,
                    children: [],
                    displayStyle: Mirror.DisplayStyle.enum
                )
            }
        }
        
        checkKnownIssue(
            NotEnum(),
            // There is no way to pass information to Mirror about case name of the case without
            // associated value. It is working for enums, because we use private API, but for
            // custom reflection for types that are not enums it is not possible.
            """
            NotEnum.<NO CASE NAME>
            """
        )
    }
    
    func test___generateCode___is_not_aware_of_field_order_in_constructor() {
        class Class {
            let a: Int
            let b: Int
            
            init(b: Int, a: Int) {
                self.a = a
                self.b = b
            }
        }
        
        checkKnownIssue(
            Class(
                b: 1,
                a: 2
            ),
            """
            Class(
                a: 2,
                b: 1
            )
            """
        )
    }
    
    // This is obvious, however, let this test be. It shows what is generated.
    func test___generateCode___can_not_generate_code_for_closures() {
        checkKnownIssue(
            { },
            """
            () -> ()((Function))
            """
        )
    }
    
    func test___generateCode___is_not_aware_of_proper_constructors_for_even_standard_types() {
        checkKnownIssue(
            [1, 2].reversed() as ReversedCollection<[Int]>,
            """
            ReversedCollection<Array<Int>>(
                _base: [
                    1,
                    2
                ]
            )
            """
        )
    }
}
