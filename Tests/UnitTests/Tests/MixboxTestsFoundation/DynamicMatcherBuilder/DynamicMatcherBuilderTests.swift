import MixboxTestsFoundation

private struct StructWithNamedFields: AllNamedKeyPathsProvider {
    let fieldWithName: Int
    let fieldWithoutName: Int
    let nestedAllNamedKeyPathsProvider: NestedAllNamedKeyPathsProvider
    let nestedNotAllNamedKeyPathsProvider: NestedNotAllNamedKeyPathsProvider
    
    static let allNamedKeyPaths = NamedKeyPaths<Self> {
        $0.fieldWithName = "fieldWithName"
        $0.nestedAllNamedKeyPathsProvider = "nestedAllNamedKeyPathsProvider"
        $0.nestedNotAllNamedKeyPathsProvider = "nestedNotAllNamedKeyPathsProvider"
    }
}

private struct NestedAllNamedKeyPathsProvider: AllNamedKeyPathsProvider {
    let field: Int
    
    static let allNamedKeyPaths = NamedKeyPaths<Self> {
        $0.field = "field"
    }
}

private struct NestedNotAllNamedKeyPathsProvider {
    let field: Int
}

final class DynamicMatcherBuilderTests: TestCase {
    private let builder = DynamicMatcherBuilder<StructWithNamedFields>()
    private let structWithNamedFields = StructWithNamedFields(
        fieldWithName: 0,
        fieldWithoutName: 1,
        nestedAllNamedKeyPathsProvider: NestedAllNamedKeyPathsProvider(
            field: 2
        ),
        nestedNotAllNamedKeyPathsProvider: NestedNotAllNamedKeyPathsProvider(
            field: 3
        )
    )
    
    func test___DynamicMatcherBuilder___produce_matcher_that_can_match_matching_field() {
        XCTAssert(
            (builder.fieldWithName == 0)
                .match(value: structWithNamedFields)
                .matched
        )
        XCTAssert(
            (builder.fieldWithoutName == 1)
                .match(value: structWithNamedFields)
                .matched
        )
        XCTAssert(
            (builder.nestedAllNamedKeyPathsProvider.field == 2)
                .match(value: structWithNamedFields)
                .matched
        )
        
        // Does not compile (correct behavior!):
        //
        // ```
        // Referencing subscript 'subscript(dynamicMember:)' on 'DynamicPropertyMatcherBuilder'
        // requires that 'NestedNotAllNamedKeyPathsProvider' conform to 'AllNamedKeyPathsProvider'`
        // ```
        //
        // XCTAssert(
        //     (builder.nestedNotAllNamedKeyPathsProvider.field == 3)
        //         .match(value: structWithNamedFields)
        //         .matched
        // )
    }
    
    func test___DynamicMatcherBuilder___produce_matcher_that_has_correct_description() {
        XCTAssertEqual(
            (builder.fieldWithName == 0).description,
            """
            has property "fieldWithName": equals to 0
            """
        )
        XCTAssertEqual(
            (builder.fieldWithoutName == 0).description,
            """
            has property "(property with unknown name, please check that `StructWithNamedFields` conforms to `AllNamedKeyPathsProvider` properly)": equals to 0
            """
        )
        XCTAssertEqual(
            (builder.nestedAllNamedKeyPathsProvider.field == 0).description,
            """
            has property "nestedAllNamedKeyPathsProvider.field": equals to 0
            """
        )
        
        // Does not compile (correct behavior!):
        //
        // ```
        // Referencing subscript 'subscript(dynamicMember:)' on 'DynamicPropertyMatcherBuilder'
        // requires that 'NestedNotAllNamedKeyPathsProvider' conform to 'AllNamedKeyPathsProvider'`
        // ```
        //
        // XCTAssertEqual(
        //     (builder.nestedNotAllNamedKeyPathsProvider.field == 0).description,
        //     """
        //     has property "field": equals to 0"
        //     """
        // )
    }
    
    func test___DynamicMatcherBuilder___produce_matcher_that_produces_correct_mismatch_description() {
        let result = (builder.fieldWithName == 1234567890)
            .match(value: structWithNamedFields)
        
        switch result {
        case .mismatch(let mismatchResult):
            XCTAssertEqual(
                mismatchResult.mismatchDescription,
                "value is not equal to '1234567890', actual value: '0'"
            )
        default:
            XCTFail("Expected mismatch, got match.")
        }
    }
}
