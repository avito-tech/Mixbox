public final class WaitingForQuiescenceElementResolver: ElementResolver {
    private let elementResolver: ElementResolver
    private let applicationQuiescenceWaiter: ApplicationQuiescenceWaiter
    
    public init(
        elementResolver: ElementResolver,
        applicationQuiescenceWaiter: ApplicationQuiescenceWaiter)
    {
        self.elementResolver = elementResolver
        self.applicationQuiescenceWaiter = applicationQuiescenceWaiter
    }
    
    public func resolveElement() throws -> ResolvedElementQuery {
        try applicationQuiescenceWaiter.waitForQuiescence()
        
        return try elementResolver.resolveElement()
    }
}
