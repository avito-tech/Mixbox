// Враппер над приватным XCAccessibilityElement.
// TODO: Доделать или выпилить. Сейчас не используется.
protocol AccessibilityElement {
}

class XcAccessibilityElement: AccessibilityElement {
    private let xcAccessibilityElement: Any
    init(_ xcAccessibilityElement: Any) {
        self.xcAccessibilityElement = xcAccessibilityElement
    }
}
