public final class ButtonElement:
    BaseElementWithDefaultInitializer,
    ButtonElementActions,
    ButtonElementChecks
{
    public var assert: ButtonElementChecks & Element {
        return ButtonElement(implementation: implementation.withAssertsInsteadOfChecks())
    }
}

public protocol ButtonElementActions:
    ViewElementActions,
    ElementWithTextActions,
    ElementWithEnabledStateActions
{
}

public protocol ButtonElementChecks:
    ViewElementChecks,
    ElementWithTextChecks,
    ElementWithEnabledStateChecks
{
}
