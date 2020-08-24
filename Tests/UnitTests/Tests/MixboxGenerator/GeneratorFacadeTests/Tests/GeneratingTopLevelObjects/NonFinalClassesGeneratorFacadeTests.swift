import XCTest
import MixboxGenerators
import MixboxStubbing

final class NonFinalClassesGeneratorFacadeTests: BaseGeneratorFacadeTests {
    func test___generate___can_generate_non_final_classes() {
        mocks.register(type: ByFieldsGenerator<BaseClass>.self) { _ in
            ByFieldsGenerator<BaseClass> { fields in
                try BaseClass(
                    baseClassField: fields.baseClassField.get()
                )
            }
        }
        
        let object: BaseClass = generator.generate {
            $0.baseClassField = 7556912100717197079
        }
        
        XCTAssertEqual(object.baseClassField, 7556912100717197079)
    }
}
