import SourceryRuntime
import MixboxMocksGeneration
import XCTest

final class TypeName_ValidTypeName_Tests: XCTestCase {
    func test___validAttributes_patch_works() {
        let typeName = TypeName(
            "@escaping(Int?) -> ()",
            attributes: [
                "escaping": Attribute(
                    name: "escaping",
                    arguments: [
                        "Int?": NSNumber(value: true)
                    ],
                    description: "@escaping(Int?)"
                )
            ],
            tuple: nil,
            array: nil,
            dictionary: nil,
            closure: nil,
            generic: nil
        )
        
        XCTAssertEqual(
            typeName.validTypeName,
            "(Int?) -> ()"
        )
        
        XCTAssertEqual(
            typeName.validAttributes.count,
            1
        )
        
        XCTAssertEqual(
            typeName.validAttributes.first?.key,
            "escaping"
        )
        
        XCTAssertEqual(
            typeName.validAttributes.first?.value.description,
            "@escaping"
        )
    }
}
