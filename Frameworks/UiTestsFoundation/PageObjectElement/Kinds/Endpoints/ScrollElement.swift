public final class ScrollElement:
    BaseElementWithDefaultInitializer,
    ScrollElementActions,
    ScrollElementChecks
{
    public var assert: ScrollElementChecks & Element {
        return ScrollElement(implementation: implementation.withAssertsInsteadOfChecks())
    }
}

public protocol ScrollElementActions:
    ViewElementActions,
    ElementWithScrollActions
{
}

public protocol ScrollElementChecks:
    ViewElementChecks,
    ElementWithScrollChecks
{
}
