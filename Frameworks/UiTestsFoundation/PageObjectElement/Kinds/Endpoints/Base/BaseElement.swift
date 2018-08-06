public protocol ElementWithDefaultInitializer: Element {
    // Если сделать инициализатор в протоколе, то он не сможет сделать нам Self в protocol extension.
    // Код: init(implementation: AlmightyElement)
    // При использовании инита пишет:
    // Method 'with(settings:)' in non-final class 'BaseElementWithDefaultInitializer' must return `Self` to conform to protocol 'Element'
    // При попытки форскаста, пишет, что форскаст из Self в Self бессмысленнен.
    // Пока так.
    init(implementation: AlmightyElement)
}

open class BaseElementWithDefaultInitializer: BaseElement, ElementWithDefaultInitializer {
    override public required init(
        implementation: AlmightyElement)
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
    public let implementation: AlmightyElement
    
    public init(
        implementation: AlmightyElement)
    {
        self.implementation = implementation
    }
}
