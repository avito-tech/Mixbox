public final class LabelElement:
    BaseElementWithDefaultInitializer,
    LabelElementActions,
    LabelElementChecks
{
    public var assert: LabelElementChecks & Element {
        return LabelElement(implementation: implementation.withAssertsInsteadOfChecks())
    }
}

public protocol LabelElementActions:
    ViewElementActions,
    ElementWithTextActions
{
}

public protocol LabelElementChecks:
    ViewElementChecks,
    ElementWithTextChecks
{
}
