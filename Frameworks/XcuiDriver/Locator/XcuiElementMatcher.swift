// Matches existing view from accessibility hierarchy.
// Difference from ElementSnapshotMatcher: ElementSnapshot always exists, XcuiElementMatcher is not an element, but a query.
struct XcuiElementMatcher {
    var matches: (_ element: XCUIElement, _ snapshot: ElementSnapshot) -> Bool
}
