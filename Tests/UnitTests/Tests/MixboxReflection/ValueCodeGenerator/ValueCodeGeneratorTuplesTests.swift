import XCTest
import MixboxReflection

final class ValueCodeGeneratorTuplesTests: BaseValueCodeGeneratorTests {
    func test___generateCode___generates_code___for_empty_tuple() {
        check(
            (),
            """
            ()
            """
        )
        
        check(
            Void(),
            """
            ()
            """
        )
    }
    
    func test___generateCode___generates_code___for_non_empty_tuple() {
        check(
            (1, label: 2),
            """
            (1, label: 2)
            """
        )
    }
}
