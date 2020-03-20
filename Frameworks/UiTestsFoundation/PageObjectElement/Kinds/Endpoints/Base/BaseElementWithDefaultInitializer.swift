open class BaseElementWithDefaultInitializer: BaseElement, ElementWithDefaultInitializer {
    override public required init(
        core: PageObjectElementCore)
    {
        super.init(core: core)
    }
    
    public func with(settings: ElementSettings) -> Self {
        return type(of: self).init(
            core: core.with(settings: settings)
        )
    }
}
