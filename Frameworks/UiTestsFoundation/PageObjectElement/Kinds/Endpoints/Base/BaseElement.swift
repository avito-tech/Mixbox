public protocol ElementWithDefaultInitializer: class, Element {
    // Если сделать инициализатор в протоколе, то он не сможет сделать нам Self в protocol extension.
    // Код: init(implementation: PageObjectElement)
    // При использовании инита пишет:
    // Method 'with(settings:)' in non-final class 'BaseElementWithDefaultInitializer' must return `Self` to conform to protocol 'Element'
    // При попытки форскаста, пишет, что форскаст из Self в Self бессмысленнен.
    // Пока так.
    init(implementation: PageObjectElement)
}

open class BaseElementWithDefaultInitializer: BaseElement, ElementWithDefaultInitializer {
    override public required init(
        implementation: PageObjectElement)
    {
        super.init(implementation: implementation)
    }
    
    public func with(settings: ElementSettings) -> Self {
        return type(of: self).init(
            implementation: implementation.with(settings: settings)
        )
    }
}

open class BaseElement {
    public let implementation: PageObjectElement
    
    public init(
        implementation: PageObjectElement)
    {
        self.implementation = implementation
    }
}
