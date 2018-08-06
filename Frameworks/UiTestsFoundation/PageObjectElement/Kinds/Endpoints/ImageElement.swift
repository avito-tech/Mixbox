public final class ImageElement:
    BaseElementWithDefaultInitializer,
    ImageElementActions,
    ImageElementChecks
{
    public var assert: ImageElementChecks & Element {
        return ImageElement(implementation: implementation.withAssertsInsteadOfChecks())
    }
}

// Use this in implementation:

public protocol ImageElementActions:
    ViewElementActions,
    ElementWithImageActions
{
}

public protocol ImageElementChecks:
    ViewElementChecks,
    ElementWithImageChecks
{
}
