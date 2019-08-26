import MixboxUiTestsFoundation
import UIKit
import XCTest

final class ElementSnapshotStub: ElementSnapshot {
    var frameRelativeToScreen: CGRect {
        set {
            _frameRelativeToScreen = newValue
        }
        get {
            return _frameRelativeToScreen ?? failAndFallback("frameRelativeToScreen", .zero)
        }
    }
    var elementType: ElementType? {
        set {
            _elementType = newValue
        }
        get {
            return _elementType ?? failAndFallback("elementType", nil)
        }
    }
    var hasKeyboardFocus: Bool {
        set {
            _hasKeyboardFocus = newValue
        }
        get {
            return _hasKeyboardFocus ?? failAndFallback("hasKeyboardFocus", false)
        }
    }
    var isEnabled: Bool {
        set {
            _isEnabled = newValue
        }
        get {
            return _isEnabled ?? failAndFallback("isEnabled", false)
        }
    }
    var accessibilityIdentifier: String {
        set {
            _accessibilityIdentifier = newValue
        }
        get {
            return _accessibilityIdentifier ?? failAndFallback("accessibilityIdentifier", "not_stubbed")
        }
    }
    var accessibilityLabel: String {
        set {
            _accessibilityLabel = newValue
        }
        get {
            return _accessibilityLabel ?? failAndFallback("accessibilityLabel", "not_stubbed")
        }
    }
    var accessibilityValue: Any? {
        set {
            _accessibilityValue = newValue
        }
        get {
            return _accessibilityValue ?? failAndFallback("accessibilityValue", nil)
        }
    }
    var accessibilityPlaceholderValue: String? {
        set {
            _accessibilityPlaceholderValue = newValue
        }
        get {
            return _accessibilityPlaceholderValue ?? failAndFallback("accessibilityPlaceholderValue", nil)
        }
    }
    var parent: ElementSnapshot? {
        set {
            _parent = newValue
        }
        get {
            return _parent ?? failAndFallback("parent", nil)
        }
    }
    var children: [ElementSnapshot] {
        set {
            _children = newValue
        }
        get {
            return _children ?? failAndFallback("children", [])
        }
    }
    var uikitClass: String? {
        set {
            _uikitClass = newValue
        }
        get {
            return _uikitClass ?? failAndFallback("uikitClass", nil)
        }
    }
    var customClass: String? {
        set {
            _customClass = newValue
        }
        get {
            return _customClass ?? failAndFallback("customClass", nil)
        }
    }
    var uniqueIdentifier: OptionalAvailability<String> {
        set {
            _uniqueIdentifier = newValue
        }
        get {
            return _uniqueIdentifier ?? failAndFallback("uniqueIdentifier", .unavailable)
        }
    }
    var isDefinitelyHidden: OptionalAvailability<Bool> {
        set {
            _isDefinitelyHidden = newValue
        }
        get {
            return _isDefinitelyHidden ?? failAndFallback("isDefinitelyHidden", .unavailable)
        }
    }
    var text: OptionalAvailability<String?> {
        set {
            _text = newValue
        }
        get {
            return _text ?? failAndFallback("text", .unavailable)
        }
    }
    var customValues: OptionalAvailability<[String: String]> {
        set {
            _customValues = newValue
        }
        get {
            return _customValues ?? failAndFallback("customValues", .unavailable)
        }
    }
    
    func add(child: ElementSnapshotStub) {
        if _children == nil {
            _children = []
        }
        
        child.parent = self
        children.append(child)
    }
    
    // Will produce failures if some property is not stubbed
    var failForNotStubbedValues = true
    
    private var _frameRelativeToScreen: CGRect?
    private var _elementType: ElementType??
    private var _hasKeyboardFocus: Bool?
    private var _isEnabled: Bool?
    private var _accessibilityIdentifier: String?
    private var _accessibilityLabel: String?
    private var _accessibilityValue: Any??
    private var _accessibilityPlaceholderValue: String??
    private var _parent: ElementSnapshot??
    private var _children: [ElementSnapshot]?
    private var _uikitClass: String??
    private var _customClass: String??
    private var _uniqueIdentifier: OptionalAvailability<String>?
    private var _isDefinitelyHidden: OptionalAvailability<Bool>?
    private var _text: OptionalAvailability<String?>?
    private var _customValues: OptionalAvailability<[String: String]>?
    
    private func failAndFallback<T>(_ propertyName: String, _ value: T) -> T {
        if failForNotStubbedValues {
            onFail(propertyName)
        }
        return value
    }
    
    private let onFail: (_ propertyName: String) -> ()
    
    init(
        onFail: ((_ propertyName: String) -> ())? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        configure: (ElementSnapshotStub) -> () = { _ in })
    {
        self.onFail = onFail ?? { propertyName in
            XCTFail("Property \(propertyName) was read, but not set", file: file, line: line)
        }
        configure(self)
    }
}
