import XCTest
import MixboxReflection
import MixboxTestsFoundation

final class EnumImmutableValueReflectionTests: TestCase {
    private enum Enum {
        case no_associated_value
        case associated_value_without_label(Int)
        case associated_value_with_label(label: Int)
        case multiple_associated_values(Int, label: String)
    }
    
    func test___reflect___works_correctly___for_no_associated_value() {
        let reflection = reflect(
            value: Enum.no_associated_value
        )
        
        XCTAssertEqual(
            reflection.caseName,
            "no_associated_value"
        )
        XCTAssertNil(
            reflection.associatedValue
        )
    }
    
    func test___reflect___works_correctly___for_associated_value_without_label() {
        let reflection = reflect(
            value: Enum.associated_value_without_label(1)
        )
        
        XCTAssertEqual(
            reflection.caseName,
            "associated_value_without_label"
        )
        
        let value = reflection.associatedValue.unwrapOrFail().primitiveOrFail()
        
        XCTAssertEqual(
            value.reflected as? Int,
            1
        )
    }
    
    func test___reflect___works_correctly___for_associated_value_with_label() {
        let reflection = reflect(
            value: Enum.associated_value_with_label(label: 1)
        )
        
        XCTAssertEqual(
            reflection.caseName,
            "associated_value_with_label"
        )
        
        let tuple = reflection.associatedValue.unwrapOrFail().tupleOrFail()
        
        let element = tuple.elements.onlyOneOrFail
        
        XCTAssertEqual(
            element.label,
            "label"
        )
        
        let primitive = element.value.primitiveOrFail()
        
        XCTAssertEqual(
            primitive.reflected as? Int,
            1
        )
    }
    
    func test___reflect___works_correctly___for_multiple_associated_values() {
        let reflection = reflect(
            value: Enum.multiple_associated_values(1, label: "2")
        )
        
        XCTAssertEqual(
            reflection.caseName,
            "multiple_associated_values"
        )
        
        let tuple = reflection.associatedValue.unwrapOrFail().tupleOrFail()
        
        let (first, second) = tuple.elements.onlyOrFail()
        
        XCTAssertNil(
            first.label
        )
        XCTAssertEqual(
            first.value.primitiveOrFail().reflected as? Int,
            1
        )
        XCTAssertEqual(
            second.label,
            "label"
        )
        XCTAssertEqual(
            second.value.primitiveOrFail().reflected as? String,
            "2"
        )
    }
    
    private func reflect(value: Enum) -> EnumImmutableValueReflection {
        EnumImmutableValueReflection.reflect(
            reflector: ReflectorImpl(
                value: value,
                mirror: Mirror(reflecting: value),
                parents: []
            )
        )
    }
}

extension TypedImmutableValueReflection {
    func primitiveOrFail() -> PrimitiveImmutableValueReflection {
        switch self {
        case .primitive(let reflection):
            return reflection
        default:
            UnavoidableFailure.fail("Value is not primitive")
        }
    }
    
    func tupleOrFail() -> TupleImmutableValueReflection {
        switch self {
        case .tuple(let reflection):
            return reflection
        default:
            UnavoidableFailure.fail("Value is not tuple")
        }
    }
}
