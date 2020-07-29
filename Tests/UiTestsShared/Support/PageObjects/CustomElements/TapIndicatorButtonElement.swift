import MixboxUiTestsFoundation

public final class TapIndicatorButtonElement:
    BaseElementWithDefaultInitializer,
    ElementWithUi,
    ElementWithText,
    ElementWithEnabledState
{
    public func assert(isTapped: Bool, file: StaticString = #file, line: UInt = #line) {
        assertMatches(file: file, line: line) {
            $0.customValues["isTapped"] == isTapped
        }
    }
}
