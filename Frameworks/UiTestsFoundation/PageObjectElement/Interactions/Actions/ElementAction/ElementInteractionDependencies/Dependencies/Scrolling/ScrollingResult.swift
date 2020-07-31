public final class ScrollingResult {
    public enum Status {
        case scrolled
        case elementWasLostAfterScroll
        case alreadyVisible(ElementVisibilityCheckerResult)
        case alreadyInHierarchyAndVisibilityCheckIsNotRequired
        case error(String)
    }
    
    public let status: Status
    public let updatedSnapshot: ElementSnapshot
    public let updatedResolvedElementQuery: ResolvedElementQuery
    
    public init(
        status: Status,
        updatedSnapshot: ElementSnapshot,
        updatedResolvedElementQuery: ResolvedElementQuery)
    {
        self.status = status
        self.updatedSnapshot = updatedSnapshot
        self.updatedResolvedElementQuery = updatedResolvedElementQuery
    }
}
