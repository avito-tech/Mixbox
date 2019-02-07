import MixboxTestsFoundation

public final class ViewElement:
    BaseElementWithDefaultInitializer,
    ViewElementActions,
    ViewElementChecks
{
    public var assert: ViewElementChecks & Element {
        return ViewElement(implementation: implementation.withAssertsInsteadOfChecks())
    }
}
