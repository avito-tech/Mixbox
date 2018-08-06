import MixboxTestsFoundation

public final class InputElement:
    BaseElementWithDefaultInitializer,
    InputElementActions,
    InputElementChecks
{
    public var assert: InputElementChecks & Element {
        return InputElement(implementation: implementation.withAssertsInsteadOfChecks())
    }
}

public protocol InputElementActions: ViewElementActions, ElementWithTextActions {}

public protocol InputElementChecks: ViewElementChecks, ElementWithTextChecks {}
