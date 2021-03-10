open class BaseElementInteractionWrapper: ElementInteraction {
    private let wrappedInteraction: ElementInteraction
    
    public init(wrappedInteraction: ElementInteraction) {
        self.wrappedInteraction = wrappedInteraction
    }
    
    public final func with(
        dependencies: ElementInteractionDependencies) -> ElementInteractionWithDependencies
    {
        return wrappedInteraction.with(dependencies: dependencies)
    }
}
