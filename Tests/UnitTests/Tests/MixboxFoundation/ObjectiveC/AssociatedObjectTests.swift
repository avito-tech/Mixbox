import MixboxFoundation
import XCTest

final class AssociatedObjectTests: TestCase {
    private class MyClass {
        let value: Int
        
        init(value: Int) {
            self.value = value
        }
    }
    
    private let nsObject = NSObject()
    
    private var associatedObject: AssociatedObject<MyClass> {
        return AssociatedObject(
            container: nsObject,
            key: "associatedObject"
        )
    }
    
    private var otherAssociatedObject: AssociatedObject<MyClass> {
        return AssociatedObject(
            container: nsObject,
            key: "otherAssociatedObject"
        )
    }
    
    func test___value___is_nil___initially() {
        XCTAssertNil(associatedObject.value)
    }
    
    func test___value___equals_to_last_set_value() {
        associatedObject.value = MyClass(value: 1)
        
        XCTAssertEqual(associatedObject.value?.value, 1)
        
        associatedObject.value = MyClass(value: 2)
        
        XCTAssertEqual(associatedObject.value?.value, 2)
        
        associatedObject.value = nil
        
        XCTAssertNil(associatedObject.value)
    }
    
    func test___value___is_unique_if_key_is_unique() {
        associatedObject.value = MyClass(value: 1)
        otherAssociatedObject.value = MyClass(value: 2)
        
        XCTAssertEqual(associatedObject.value?.value, 1)
        XCTAssertEqual(otherAssociatedObject.value?.value, 2)
    }
}
