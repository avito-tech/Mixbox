public protocol ElementWithDefaultInitializer: Element {
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
