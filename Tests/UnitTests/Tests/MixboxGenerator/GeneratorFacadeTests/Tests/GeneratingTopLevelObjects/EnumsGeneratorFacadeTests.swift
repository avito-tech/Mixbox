import XCTest
import MixboxGenerators
import MixboxStubbing

// swiftlint:disable multiline_arguments
final class EnumsGeneratorFacadeTests: BaseGeneratorFacadeTests {
    func test___generate___can_generate_CaseIterable_enums() {
        setRandom(0, continueSequenceWithMoreNumbers: false)
        
        XCTAssertEqual(
            generator.generate() as CaseIterableEnum,
            CaseIterableEnum.allCases[0]
        )
        
        setRandom(1, continueSequenceWithMoreNumbers: false)
        
        XCTAssertEqual(
            generator.generate() as CaseIterableEnum,
            CaseIterableEnum.allCases[1]
        )
    }
    
    func test___generate___can_generate_enums_with_associated_values___low_level_check() {
        stubDefaultConstants()
        
        func assert(randomInts: UInt64..., expectedValue: CaseGeneratableEnumWithAssociatedValues) {
            setRandom(randomInts, continueSequenceWithMoreNumbers: false)
            
            XCTAssertEqual(
                generator.generate() as CaseGeneratableEnumWithAssociatedValues,
                expectedValue
            )
        }
        
        assert(
            randomInts: 0,
            expectedValue: .case_0_no_associated_value
        )
        
        assert(
            randomInts: 1,
            expectedValue: .case_1_primitive(generatedByDefault())
        )
        
        assert(
            randomInts: 2, 1,
            expectedValue: .case_2_nesting_same_type(.case_1_primitive(generatedByDefault()))
        )
        
        assert(
            randomInts: 3,
            expectedValue: .case_3_nesting_structure(generatedByDefault())
        )
        
        assert(
            randomInts: 4,
            expectedValue: .case_4_nesting_multiple_values(generatedByDefault(), generatedByDefault())
        )
    }
    
    func test___generate___fails_test_if_CaseGeneratable_DefaultGeneratorProvider_returns_empty_allCasesGenerators() {
        assertFails {
            _ = generator.generate() as CaseGeneratableEnumWithoutCases
        }
    }
    
    private indirect enum CaseGeneratableEnumWithAssociatedValues: Equatable, CaseGeneratable, DefaultGeneratorProvider {
        case case_0_no_associated_value
        case case_1_primitive(Int)
        case case_2_nesting_same_type(CaseGeneratableEnumWithAssociatedValues)
        case case_3_nesting_structure(Structure)
        case case_4_nesting_multiple_values(Structure, Structure)
        
        static func ==(lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.case_0_no_associated_value, .case_0_no_associated_value):
                return true
            case let (.case_1_primitive(lhs), .case_1_primitive(rhs)):
                return lhs == rhs
            case let (.case_2_nesting_same_type(lhs), .case_2_nesting_same_type(rhs)):
                return lhs == rhs
            case let (.case_3_nesting_structure(lhs), .case_3_nesting_structure(rhs)):
                return lhs == rhs
            case let (.case_4_nesting_multiple_values(lhs), .case_4_nesting_multiple_values(rhs)):
                return lhs.0 == rhs.0 && lhs.1 == rhs.1
            default:
                return false
            }
        }
        
        static var allCasesGenerators: AllCasesGenerators<Self> {
            [
                { _ in .case_0_no_associated_value },
                { .case_1_primitive(try $0.generate()) },
                { .case_2_nesting_same_type(try $0.generate()) },
                { .case_3_nesting_structure(try $0.generate()) },
                { .case_4_nesting_multiple_values(try $0.generate(), try $0.generate()) }
            ]
        }
    }

    private enum CaseGeneratableEnumWithoutCases: Equatable, CaseGeneratable, DefaultGeneratorProvider {
        static let allCasesGenerators: AllCasesGenerators<Self> = []
    }

    private enum CaseIterableEnum: String, Equatable, CaseIterable, DefaultGeneratorProvider {
        case case0
        case case1
    }
}
