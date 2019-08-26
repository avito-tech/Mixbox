import XCTest
import MixboxUiTestsFoundation

final class ElementSnapshotStubTests: XCTestCase {
    func test___ElementSnapshotStub___return_stubbed_values() {
        let stub = ElementSnapshotStub {
            $0.frameRelativeToScreen = CGRect(x: 1, y: 2, width: 3, height: 4)
            $0.elementType = .button
            $0.hasKeyboardFocus = true
            $0.isEnabled = false
            $0.accessibilityIdentifier = "accessibilityIdentifier"
            $0.accessibilityLabel = "accessibilityLabel"
            $0.accessibilityValue = "accessibilityValue"
            $0.accessibilityPlaceholderValue = "accessibilityPlaceholderValue"
            $0.parent = ElementSnapshotStub { $0.accessibilityIdentifier = "parent" }
            $0.children = [ElementSnapshotStub { $0.accessibilityIdentifier = "child" }]
            $0.uikitClass = "uikitClass"
            $0.customClass = "customClass"
            $0.uniqueIdentifier = .available("uniqueIdentifier")
            $0.isDefinitelyHidden = .available(true)
            $0.text = .available("text")
            $0.customValues = .available(["customValues": "customValues"])
        }
        
        XCTAssertEqual(stub.frameRelativeToScreen, CGRect(x: 1, y: 2, width: 3, height: 4))
        XCTAssertEqual(stub.elementType, .button)
        XCTAssertEqual(stub.hasKeyboardFocus, true)
        XCTAssertEqual(stub.isEnabled, false)
        XCTAssertEqual(stub.accessibilityIdentifier, "accessibilityIdentifier")
        XCTAssertEqual(stub.accessibilityLabel, "accessibilityLabel")
        XCTAssertEqual(stub.accessibilityValue as? String, "accessibilityValue")
        XCTAssertEqual(stub.accessibilityPlaceholderValue, "accessibilityPlaceholderValue")
        XCTAssertEqual(stub.parent?.accessibilityIdentifier, "parent")
        XCTAssertEqual(stub.children.map { $0.accessibilityIdentifier }, ["child"])
        XCTAssertEqual(stub.uikitClass, "uikitClass")
        XCTAssertEqual(stub.customClass, "customClass")
        XCTAssertEqual(stub.uniqueIdentifier.valueIfAvailable, "uniqueIdentifier")
        XCTAssertEqual(stub.isDefinitelyHidden.valueIfAvailable, true)
        XCTAssertEqual(stub.text.valueIfAvailable, "text")
        XCTAssertEqual(stub.customValues.valueIfAvailable?["customValues"], "customValues")
    }
    
    func test___ElementSnapshotStub___provides_default_values___if_failForNotStubbedValues_is_false() {
        let stub = ElementSnapshotStub()
        stub.failForNotStubbedValues = false
        
        XCTAssertEqual(stub.frameRelativeToScreen, .zero)
        XCTAssertNil(stub.elementType)
        XCTAssertEqual(stub.hasKeyboardFocus, false)
        XCTAssertEqual(stub.isEnabled, false)
        XCTAssertEqual(stub.accessibilityIdentifier, "not_stubbed")
        XCTAssertEqual(stub.accessibilityLabel, "not_stubbed")
        XCTAssertNil(stub.accessibilityValue)
        XCTAssertEqual(stub.accessibilityPlaceholderValue, nil)
        XCTAssertNil(stub.parent)
        XCTAssert(stub.children.isEmpty)
        XCTAssertNil(stub.uikitClass)
        XCTAssertNil(stub.customClass)
        XCTAssertEqual(stub.uniqueIdentifier, .unavailable)
        XCTAssertEqual(stub.isDefinitelyHidden, .unavailable)
        XCTAssertEqual(stub.text, .unavailable)
        XCTAssertEqual(stub.customValues, .unavailable)
    }
    
    // swiftlint:disable:next function_body_length
    func test___ElementSnapshotStub___fails___if_values_are_not_stubbed_and_failForNotStubbedValues_is_true() {
        var failedProperties = [String]()
        
        let stub = ElementSnapshotStub(
            onFail: { failedProperties.append($0) }
        )
        
        _ = stub.frameRelativeToScreen
        XCTAssertEqual(failedProperties, ["frameRelativeToScreen"])
        failedProperties.removeAll()
        
        _ = stub.elementType
        XCTAssertEqual(failedProperties, ["elementType"])
        failedProperties.removeAll()
        
        _ = stub.hasKeyboardFocus
        XCTAssertEqual(failedProperties, ["hasKeyboardFocus"])
        failedProperties.removeAll()
        
        _ = stub.isEnabled
        XCTAssertEqual(failedProperties, ["isEnabled"])
        failedProperties.removeAll()
        
        _ = stub.accessibilityIdentifier
        XCTAssertEqual(failedProperties, ["accessibilityIdentifier"])
        failedProperties.removeAll()
        
        _ = stub.accessibilityLabel
        XCTAssertEqual(failedProperties, ["accessibilityLabel"])
        failedProperties.removeAll()
        
        _ = stub.accessibilityValue
        XCTAssertEqual(failedProperties, ["accessibilityValue"])
        failedProperties.removeAll()
        
        _ = stub.accessibilityPlaceholderValue
        XCTAssertEqual(failedProperties, ["accessibilityPlaceholderValue"])
        failedProperties.removeAll()
        
        _ = stub.parent?.accessibilityIdentifier
        XCTAssertEqual(failedProperties, ["parent"])
        failedProperties.removeAll()
        
        _ = stub.children.first?.accessibilityIdentifier
        XCTAssertEqual(failedProperties, ["children"])
        failedProperties.removeAll()
        
        _ = stub.uikitClass
        XCTAssertEqual(failedProperties, ["uikitClass"])
        failedProperties.removeAll()
        
        _ = stub.customClass
        XCTAssertEqual(failedProperties, ["customClass"])
        failedProperties.removeAll()
        
        _ = stub.uniqueIdentifier.valueIfAvailable
        XCTAssertEqual(failedProperties, ["uniqueIdentifier"])
        failedProperties.removeAll()
        
        _ = stub.isDefinitelyHidden.valueIfAvailable
        XCTAssertEqual(failedProperties, ["isDefinitelyHidden"])
        failedProperties.removeAll()
        
        _ = stub.text.valueIfAvailable
        XCTAssertEqual(failedProperties, ["text"])
        failedProperties.removeAll()
        
        _ = stub.customValues.valueIfAvailable?["customValues"]
        XCTAssertEqual(failedProperties, ["customValues"])
        failedProperties.removeAll()
    }
    
    func test___ElementSnapshotStub___add_child() {
        let stub = ElementSnapshotStub()
        
        stub.add(
            child: ElementSnapshotStub { $0.accessibilityIdentifier = "child" }
        )
        
        XCTAssertEqual(
            stub.children.map { $0.accessibilityIdentifier },
            ["child"]
        )
    }
}
