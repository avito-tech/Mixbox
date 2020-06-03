import MixboxFoundation
import XCTest

private final class TypeWithNameThatShouldBeNeverChanged {}

// TODO: Make Bool & Int CustomDebugStringConvertible?
final class DebugDescriptionBuilderTests: TestCase {
    func test___debugDescription___when_initialized_with_name() {
        let description = DebugDescriptionBuilder(name: "Name").debugDescription
        
        XCTAssertEqual(
            description,
            """
            Name()
            """
        )
    }
    
    func test___debugDescription___when_initialized_with_type() {
        let description = DebugDescriptionBuilder(type: TypeWithNameThatShouldBeNeverChanged.self).debugDescription
        
        XCTAssertEqual(
            description,
            """
            TypeWithNameThatShouldBeNeverChanged()
            """
        )
    }
    
    func test___debugDescription___when_initialized_with_typeOf() {
        let description = DebugDescriptionBuilder(typeOf: TypeWithNameThatShouldBeNeverChanged()).debugDescription
        
        XCTAssertEqual(
            description,
            """
            TypeWithNameThatShouldBeNeverChanged()
            """
        )
    }
    
    func test___debugDescription___when_value_is_added() {
        let description = DebugDescriptionBuilder(name: "Name")
            .add(name: "key", value: "value")
            .debugDescription
        
        XCTAssertEqual(
            description,
            """
            Name(
                key: "value"
            )
            """
        )
    }
    
    func test___debugDescription___when_nil_value_is_added() {
        let description = DebugDescriptionBuilder(name: "Name")
            .add(name: "key", value: nil as Int?)
            .debugDescription
        
        XCTAssertEqual(
            description,
            """
            Name(
                key: nil
            )
            """
        )
    }
    
    func test___debugDescription___when_array_is_added() {
        let description = DebugDescriptionBuilder(name: "Name")
            .add(name: "array", array: ["1", "2", "3"])
            .debugDescription
        
        XCTAssertEqual(
            description,
            """
            Name(
                array: [
                    "1",
                    "2",
                    "3"
                ]
            )
            """
        )
    }
    
    func test___debugDescription___when_nil_array_is_added() {
        let description = DebugDescriptionBuilder(name: "Name")
            .add(name: "array", array: nil as [Int]?)
            .debugDescription
        
        XCTAssertEqual(
            description,
            """
            Name(
                array: nil
            )
            """
        )
    }
    
    func test___debugDescription___when_dictionary_is_added() {
        let description = DebugDescriptionBuilder(name: "Name")
            .add(name: "dictionary", dictionary: ["1": "2"])
            .debugDescription
        
        XCTAssertEqual(
            description,
            """
            Name(
                dictionary: [
                    "1": "2"
                ]
            )
            """
        )
    }
    
    func test___debugDescription___when_nil_dictionary_is_added() {
        let description = DebugDescriptionBuilder(name: "Name")
            .add(name: "dictionary", dictionary: nil as [Int: Int]?)
            .debugDescription
        
        XCTAssertEqual(
            description,
            """
            Name(
                dictionary: nil
            )
            """
        )
    }
    
    func test___debugDescription___when_multiple_values_are_added() {
        // I think it's fine to allow adding fields with same names, empty names, etc.
        let description = DebugDescriptionBuilder(name: "Name")
            .add(name: "key", value: "1")
            .add(name: "key", value: "2")
            .add(name: "key", value: "3")
            .debugDescription
        
        XCTAssertEqual(
            description,
            """
            Name(
                key: "1",
                key: "2",
                key: "3"
            )
            """
        )
    }
}
