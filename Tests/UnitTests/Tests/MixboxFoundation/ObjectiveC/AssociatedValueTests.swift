import MixboxFoundation
import XCTest

final class AssociatedValueTests: TestCase {
    private let nsObject = NSObject()
    private let defaultValue = 1
    private var associatedValue: AssociatedValue<Int> {
        return AssociatedValue(
            container: nsObject,
            key: "associatedValue",
            defaultValue: defaultValue
        )
    }
    
    func test___value___equals_to_default_value___initially() {
        XCTAssertEqual(associatedValue.value, defaultValue)
    }
    
    func test___value___equals_to_last_set_value() {
        associatedValue.value = 1
        
        XCTAssertEqual(associatedValue.value, 1)
        
        associatedValue.value = 2
        
        XCTAssertEqual(associatedValue.value, 2)
    }
}
