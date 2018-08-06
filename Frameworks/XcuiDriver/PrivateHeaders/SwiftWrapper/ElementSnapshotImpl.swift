import XCTest
import MixboxIpcCommon
import MixboxUiTestsFoundation

// Swift обертка над приватным Obj-C XCElementSnapshot
class ElementSnapshotImpl: ElementSnapshot {
    private let xcElementSnapshot: XCElementSnapshot
    
    init(_ xcElementSnapshot: XCElementSnapshot) {
        self.xcElementSnapshot = xcElementSnapshot
    }
    
    var enhancedAccessibilityValue: EnhancedAccessibilityValue? {
        return EnhancedAccessibilityValue.fromAccessibilityValue(value as? String)
    }
    
    var hasFocus: Bool {
        return xcElementSnapshot.hasFocus
    }
    var hasKeyboardFocus: Bool {
        return xcElementSnapshot.hasKeyboardFocus
    }
    var isMainWindow: Bool {
        return xcElementSnapshot.isMainWindow
    }
    var isTopLevelTouchBarElement: Bool  {
        return xcElementSnapshot.isTopLevelTouchBarElement
    }
    var isTouchBarElement: Bool  {
        return xcElementSnapshot.isTouchBarElement
    }
    var verticalSizeClass: XCUIElement.SizeClass {
        return xcElementSnapshot.verticalSizeClass
    }
    var horizontalSizeClass: XCUIElement.SizeClass {
        return xcElementSnapshot.horizontalSizeClass
    }
    var selected: Bool {
        return xcElementSnapshot.isSelected // TODO: selected?
    }
    var enabled: Bool {
        return xcElementSnapshot.isEnabled // TODO: enabled?
    }
    var elementType: ElementType? {
        return ElementType(rawValue: UInt(xcElementSnapshot.elementType.rawValue))
    }
    var placeholderValue: String? {
        return xcElementSnapshot.placeholderValue as String?
    }
    var label: String {
        return xcElementSnapshot.label
    }
    var title: String {
        return xcElementSnapshot.title
    }
    var value: Any? {
        return xcElementSnapshot.value
    }
    var identifier: String {
        return xcElementSnapshot.identifier
    }
    var frame: CGRect {
        return xcElementSnapshot.frame
    }
    var visibleFrame: CGRect {
        return xcElementSnapshot.visibleFrame
    }
    
    var additionalAttributes: [NSObject: Any]  {
        return xcElementSnapshot.additionalAttributes as [NSObject: Any]
    }
    var userTestingAttributes: [Any] {
        return xcElementSnapshot.userTestingAttributes as [Any]
    }
    var traits: UInt64 {
        return xcElementSnapshot.traits
    }
    var children: [Any] {
        return xcElementSnapshot.children as [Any]
    }
    var parent: ElementSnapshot? {
        guard let parent = xcElementSnapshot.parent else {
            return nil
        }
        return ElementSnapshotImpl(parent)
    }
    var suggestedHitpoints: [Any] {
        return xcElementSnapshot.suggestedHitpoints as [Any]
    }
    var scrollView: ElementSnapshot? {
        guard let scrollView = xcElementSnapshot.scrollView else {
            return nil
        }
        return ElementSnapshotImpl(scrollView)
    }
    var truncatedValueString: String? {
        return xcElementSnapshot.truncatedValueString as String?
    }
    var depth: Int64 {
        return xcElementSnapshot.depth
    }
    var pathFromRoot: ElementSnapshot? {
        guard let pathFromRoot = xcElementSnapshot.pathFromRoot else {
            return nil
        }
        return ElementSnapshotImpl(pathFromRoot)
    }
    var sparseTreeDescription: String? {
        return xcElementSnapshot.sparseTreeDescription as String?
    }
    var compactDescription: String? {
        return xcElementSnapshot.compactDescription as String?
    }
    var pathDescription: String? {
        return xcElementSnapshot.pathDescription as String?
    }
    var recursiveDescriptionIncludingAccessibilityElement: String? {
        return xcElementSnapshot.recursiveDescriptionIncludingAccessibilityElement as String?
    }
    var recursiveDescription: String? {
        return xcElementSnapshot.recursiveDescription as String?
    }
    var identifiers: [Any] {
        return xcElementSnapshot.identifiers as [Any]
    }
    var generation: UInt64 {
        return xcElementSnapshot.generation
    }
    var application: XCUIApplication? {
        return xcElementSnapshot.application
    }
    func rootElement() -> ElementSnapshot? {
        guard let rootElement = xcElementSnapshot.rootElement() else {
            return nil
        }
        return ElementSnapshotImpl(rootElement)
    }
}

extension ElementSnapshotImpl {
    public var debugDescription: String {
        var fields = [String]()
        fields.append("hasFocus: \(hasFocus)")
        fields.append("hasKeyboardFocus: \(hasKeyboardFocus)")
        fields.append("isMainWindow: \(isMainWindow)")
        if let parent = xcElementSnapshot.parent {
            fields.append("parent: \(parent)")
        }
        fields.append("horizontalSizeClass: \(horizontalSizeClass)")
        fields.append("verticalSizeClass: \(verticalSizeClass)")
        fields.append("frame: \(frame)")
        if let elementType = elementType {
            fields.append("elementType: \(elementType)")
        }
        fields.append("traits: \(traits)")
        fields.append("children: \(children)")
        fields.append("userTestingAttributes: \(userTestingAttributes)")
        fields.append("additionalAttributes: \(additionalAttributes)")
        fields.append("identifier: \(identifier)")
        fields.append("label: \(label)")
        if let placeholderValue = placeholderValue {
            fields.append("placeholderValue: \(placeholderValue)")
        }
        fields.append("title: \(title)")
        if let value = value {
            fields.append("value: \(value)")
        }
        fields.append("isEnabled: \(enabled)")
        fields.append("isSelected: \(selected)")
        if let application = application {
            fields.append("application: \(application)")
        }
        fields.append("generation: \(generation)")
        fields.append("isTopLevelTouchBarElement: \(isTopLevelTouchBarElement)")
        fields.append("isTouchBarElement: \(isTouchBarElement)")
        fields.append("suggestedHitpoints: \(suggestedHitpoints)")
        if let recursiveDescription = recursiveDescription {
            fields.append("recursiveDescription: \(recursiveDescription)")
        }
        if let recursiveDescriptionIncludingAccessibilityElement = recursiveDescriptionIncludingAccessibilityElement {
            fields.append("recursiveDescriptionIncludingAccessibilityElement: \(recursiveDescriptionIncludingAccessibilityElement)")
        }
        if let scrollView = xcElementSnapshot.scrollView {
            fields.append("scrollView: \(scrollView)")
        }
        fields.append("depth: \(depth)")
        fields.append("visibleFrame: \(visibleFrame)")
        fields.append("identifiers: \(identifiers)")
        if let compactDescription = compactDescription {
            fields.append("compactDescription: \(compactDescription)")
        }
        if let pathDescription = pathDescription {
            fields.append("pathDescription: \(pathDescription)")
        }
        if let sparseTreeDescription = sparseTreeDescription {
            fields.append("sparseTreeDescription: \(sparseTreeDescription)")
        }
        if let truncatedValueString = truncatedValueString {
            fields.append("truncatedValueString: \(truncatedValueString)")
        }
        if let pathFromRoot = xcElementSnapshot.pathFromRoot {
            fields.append("pathFromRoot: \(pathFromRoot)")
        }
        return fields.joined(separator: "\n")
    }
}
