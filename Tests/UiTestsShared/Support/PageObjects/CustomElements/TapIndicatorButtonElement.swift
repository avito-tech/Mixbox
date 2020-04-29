import MixboxUiTestsFoundation

public final class TapIndicatorButtonElement:
    BaseElementWithDefaultInitializer,
    ElementWithUi,
    ElementWithText,
    ElementWithEnabledState
{
    public func assert(isTapped: Bool) {
        assertMatches {
            $0.customValues["isTapped"] == isTapped
        }
    }
}
