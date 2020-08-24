import XCTest

// Note: generation logic is already tested in `NestedFieldsGeneratorFacadeTests`
// This test checks that `GeneratorFacade` can generate arrays not only for nested fields.
//
// See also: `TestFailingArrayGenerator`
final class ArrayGeneratorFacadeTests: BaseGeneratorFacadeTests {
    func test___array___without_fields() {
        setRandom([1, 2, 3])
        
        XCTAssertEqual(
            generator.array(count: 3),
            [1, 2, 3]
        )
    }
    
    func test___array___with_fields() {
        XCTAssertEqual(
            generator.array(count: 2) {
                $0.int = 1
                $0.string = "1"
            },
            [
                Structure(int: 1, string: "1"),
                Structure(int: 1, string: "1")
            ]
        )
    }
}
