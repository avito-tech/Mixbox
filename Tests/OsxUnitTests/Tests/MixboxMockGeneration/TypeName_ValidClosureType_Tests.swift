import SourceryRuntime
import MixboxMocksGeneration
import XCTest

final class TypeName_ValidClosureType_Tests: XCTestCase {
    func test___with_attributes() {
        let typeName = TypeName(
            "@escaping(Int?) -> ()"
        )
        
        XCTAssertEqual(
            typeName.validClosureType?.name,
            "(Int?) -> ()"
        )
    }
    
    func test___with_array() {
        let typeName = TypeName(
            "[() -> ()]"
        )
        
        XCTAssertEqual(
            typeName.validClosureType?.name,
            nil
        )
    }
    
    func test___with_optional_closure() {
        let typeName = TypeName("((String, Int) -> (Int))?")
        
        XCTAssertEqual(
            typeName.validClosureType?.parameters.count,
            2
        )
        
        XCTAssertEqual(
            typeName.validClosureType?.parameters.first?.typeName.validTypeName,
            "String"
        )
        
        XCTAssertEqual(
            typeName.validClosureType?.parameters.last?.typeName.validTypeName,
            "Int"
        )
        
        XCTAssertEqual(
            typeName.validClosureType?.returnTypeName.validTypeName,
            "Int"
        )
    }
}
