import XCTest

// Note: generation logic is already tested in `NestedFieldsGeneratorFacadeTests`
// This test checks that `GeneratorFacade` can generate dictionaries not only for nested fields.
//
// See also: `TestFailingArrayGenerator`
final class DictionaryGeneratorFacadeTests: BaseGeneratorFacadeTests {
    func test___dictionary___without_fields() {
        setRandom([1, 2, 3, 4])
        
        XCTAssertEqual(
            generator.dictionary(count: 2),
            [1: 2, 3: 4]
        )
    }
    
    func test___dictionary___with_fields_for_keys() {
        setRandom([100, 200])
        
        XCTAssertEqual(
            generator.dictionary(count: 2) {
                $0.int = $0.index() + 1
                $0.string = "\($0.index() + 1)"
            } as [Structure: Int],
            [
                Structure(int: 1, string: "1"): 100,
                Structure(int: 2, string: "2"): 200
            ]
        )
    }
    
    func test___dictionary___with_fields_for_values() {
        setRandom([100, 200])
        
        XCTAssertEqual(
            generator.dictionary(count: 2) {
                $0.int = $0.index() + 1
                $0.string = "\($0.index() + 1)"
            } as [Int: Structure],
            [
                100: Structure(int: 1, string: "1"),
                200: Structure(int: 2, string: "2")
            ]
        )
    }
    
    func test___dictionary___with_fields_for_keys_and_values() {
        XCTAssertEqual(
            generator.dictionary(
                count: 2,
                keys: {
                    $0.int = $0.index() + 1
                    $0.string = "\($0.index() + 1)"
                },
                values: {
                    $0.int = ($0.index() + 1) * 100
                    $0.string = "\(($0.index() + 1) * 100)"
                }
            ) as [Structure: Structure],
            [
                Structure(int: 1, string: "1"): Structure(int: 100, string: "100"),
                Structure(int: 2, string: "2"): Structure(int: 200, string: "200")
            ]
        )
    }
}
