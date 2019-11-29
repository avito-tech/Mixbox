import MixboxUiTestsFoundation

struct AssertSpecification<ElementType: Element> {
    var element: (ChecksTestsViewPageObject) -> (ElementType)
    var assert: (ElementType) -> ()
}
