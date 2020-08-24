import XCTest

// Note: generation logic is already tested in `NestedFieldsGeneratorFacadeTests`
// This test checks that `GeneratorFacade` can generate optionals not only for nested fields.
//
// See also: `TestFailingArrayGenerator`
final class OptionalGeneratorFacadeTests: BaseGeneratorFacadeTests {
    func test___some___without_fields() {
        setRandom([1])
        
        XCTAssertEqual(
            generator.some() as Int?,
            1
        )
    }
    
    func test___some___with_fields() {
        XCTAssertEqual(
            generator.some {
                $0.int = 1
                $0.string = "1"
            } as Structure?,
            Structure(int: 1, string: "1")
        )
    }
}
