import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class TapIndicatorButtonElement:
    BaseElementWithDefaultInitializer,
    ElementWithUi,
    ElementWithText,
    ElementWithEnabledState
{
    public func assert(isTapped: Bool, file: StaticString = #filePath, line: UInt = #line) {
        assertMatches(file: file, line: line) {
            $0.customValues["isTapped"] == isTapped
        }
    }
}
