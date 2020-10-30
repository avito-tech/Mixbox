import XCTest
import MixboxReflection

extension BaseValueCodeGeneratorTests {
    @nonobjc func check(_ value: Any, _ code: String, typeCanBeInferredFromContext: Bool = false) {
        let codeGenerator = ValueCodeGeneratorImpl(indentation: "    ")
        XCTAssertEqual(
            codeGenerator.generateCode(value: value, typeCanBeInferredFromContext: typeCanBeInferredFromContext),
            code
        )
    }
    
    // It's a separate function with a different name to make the semantics more obvious
    @nonobjc func checkKnownIssue(_ value: Any, _ actual: String, typeCanBeInferredFromContext: Bool = false) {
        check(value, actual, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
    }

    // `@objc` will cause bridging from Swift types to ObjC types, e.g. Int to __NSCFNumber.
    // This doesn't work if this method is declared inside the class where it is used.
    @objc func checkKnownIssueWithValueBridgedToObjectiveC(_ value: Any, _ actual: String) {
        let codeGenerator = ValueCodeGeneratorImpl(indentation: "    ")
        XCTAssertEqual(
            codeGenerator.generateCode(value: value, typeCanBeInferredFromContext: false),
            actual
        )
    }
}
