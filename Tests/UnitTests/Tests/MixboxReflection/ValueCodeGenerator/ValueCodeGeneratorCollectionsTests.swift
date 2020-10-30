import XCTest
import MixboxReflection

final class ValueCodeGeneratorCollectionsTests: BaseValueCodeGeneratorTests {
    func test___generateCode___generates_code___for_empty_array() {
        check(
            [],
            """
            []
            """,
            typeCanBeInferredFromContext: true
        )
        
        check(
            [],
            """
            Array<Any>([])
            """,
            typeCanBeInferredFromContext: false
        )
    }
    
    func test___generateCode___generates_code___for_non_empty_array() {
        check(
            [
                1,
                2
            ],
            """
            [
                1,
                2
            ]
            """,
            typeCanBeInferredFromContext: true
        )
        
        check(
            [
                1,
                2
            ],
            """
            Array<Int>([
                1,
                2
            ])
            """,
            typeCanBeInferredFromContext: false
        )
    }
    
    func test___generateCode___generates_code___for_ArraySlice() {
        // This line checks and shows that ArraySlice can be initialized from
        // code that ValueCodeGenerator generates
        let collection: ArraySlice<Int> = [1]
        
        checkKnownIssue(
            collection,
            // Despite the code is valid, ValueCodeGenerator doesn't know
            // if `ArraySlice` can be initialized with array literal
            // Expected result is just:
            // ```
            // [
            //     1
            // ]
            // ```
            """
            ArraySlice<Int>([
                1
            ])
            """,
            typeCanBeInferredFromContext: true
        )
        
        check(
            collection,
            """
            ArraySlice<Int>([
                1
            ])
            """,
            typeCanBeInferredFromContext: false
        )
    }
}
