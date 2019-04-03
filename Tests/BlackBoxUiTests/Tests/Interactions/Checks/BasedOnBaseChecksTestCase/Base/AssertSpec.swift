import MixboxUiTestsFoundation

struct AssertSpecification<ElementType: Element> {
    var element: (ChecksTestsScreen) -> (ElementType)
    var assert: (ElementType) -> ()
}
