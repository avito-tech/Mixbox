import XCTest

final class ElementSnapshotStubTests: XCTestCase {
    func test_ElementSnapshotStub_values() {
        let stub = ElementSnapshotStub(
            configure: {
                $0.frameOnScreen = CGRect(x: 1, y: 2, width: 3, height: 4)
                $0.elementType = .button
                $0.hasKeyboardFocus = true
                $0.isEnabled = false
                $0.accessibilityIdentifier = "accessibilityIdentifier"
                $0.accessibilityLabel = "accessibilityLabel"
                $0.accessibilityValue = "accessibilityValue"
                $0.accessibilityPlaceholderValue = "accessibilityPlaceholderValue"
                $0.parent = ElementSnapshotStub { $0.accessibilityIdentifier = "parent" }
                $0.children = [ElementSnapshotStub { $0.accessibilityIdentifier = "children" }]
                $0.uikitClass = "uikitClass"
                $0.customClass = "customClass"
                $0.uniqueIdentifier = .available("uniqueIdentifier")
                $0.isDefinitelyHidden = .available(true)
                $0.visibleText = .available("visibleText")
                $0.customValues = .available(["customValues": "customValues"])
            }
        )
        
        XCTAssertEqual(stub.frameOnScreen, CGRect(x: 1, y: 2, width: 3, height: 4))
        XCTAssertEqual(stub.elementType, .button)
        XCTAssertEqual(stub.hasKeyboardFocus, true)
        XCTAssertEqual(stub.isEnabled, false)
        XCTAssertEqual(stub.accessibilityIdentifier, "accessibilityIdentifier")
        XCTAssertEqual(stub.accessibilityLabel, "accessibilityLabel")
        XCTAssertEqual(stub.accessibilityValue as? String, "accessibilityValue")
        XCTAssertEqual(stub.accessibilityPlaceholderValue, "accessibilityPlaceholderValue")
        XCTAssertEqual(stub.parent?.accessibilityIdentifier, "parent")
        XCTAssertEqual(stub.children.map { $0.accessibilityIdentifier }, ["children"])
        XCTAssertEqual(stub.uikitClass, "uikitClass")
        XCTAssertEqual(stub.customClass, "customClass")
        XCTAssertEqual(stub.uniqueIdentifier.value, "uniqueIdentifier")
        XCTAssertEqual(stub.isDefinitelyHidden.value, true)
        XCTAssertEqual(stub.visibleText.value, "visibleText")
        XCTAssertEqual(stub.customValues.value?["customValues"], "customValues")
    }
    
    func test_ElementSnapshotStub_fails() {
        var failedProperties = [String]()
        
        let stub = ElementSnapshotStub(
            onFail: { failedProperties.append($0) },
            configure: { _ in }
        )
        
        _ = stub.frameOnScreen
        XCTAssertEqual(failedProperties, ["frameOnScreen"])
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
        
        _ = stub.uniqueIdentifier.value
        XCTAssertEqual(failedProperties, ["uniqueIdentifier"])
        failedProperties.removeAll()
        
        _ = stub.isDefinitelyHidden.value
        XCTAssertEqual(failedProperties, ["isDefinitelyHidden"])
        failedProperties.removeAll()
        
        _ = stub.visibleText.value
        XCTAssertEqual(failedProperties, ["visibleText"])
        failedProperties.removeAll()
        
        _ = stub.customValues.value?["customValues"]
        XCTAssertEqual(failedProperties, ["customValues"])
        failedProperties.removeAll()
    }
}
