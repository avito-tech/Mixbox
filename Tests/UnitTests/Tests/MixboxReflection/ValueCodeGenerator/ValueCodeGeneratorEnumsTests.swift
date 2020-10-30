import XCTest
import MixboxReflection

final class ValueCodeGeneratorEnumsTests: BaseValueCodeGeneratorTests {
    func test___generateCode___generates_code___for_enum_case_with_no_associated_value() {
        check(
            Enum.no_associated_value,
            """
            Enum.no_associated_value
            """
        )
    }
    
    func test___generateCode___generates_code___for_enum_case_with_associated_value_without_label() {
        check(
            Enum.associated_value_without_label(42),
            """
            Enum.associated_value_without_label(42)
            """
        )
    }
    
    func test___generateCode___generates_code___for_enum_case_with_associated_value_with_label() {
        check(
            Enum.associated_value_with_label(label: 42),
            """
            Enum.associated_value_with_label(label: 42)
            """
        )
    }
    
    func test___generateCode___generates_code___for_enum_case_with_multiple_associated_values() {
        check(
            Enum.multiple_associated_values(1, label: "2", struct: Struct(
                int: 3,
                string: "4"
            )),
            """
            Enum.multiple_associated_values(1, label: "2", struct: Struct(
                int: 3,
                string: "4"
            ))
            """
        )
    }
}
