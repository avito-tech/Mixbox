import MixboxUiTestsFoundation

final class ScrollingResult {
    enum Status {
        case scrolled
        case elementWasLostAfterScroll
        case alreadyVisible(percentageOfVisibleArea: CGFloat)
        case internalError(String)
    }
    
    let status: Status
    let updatedSnapshot: ElementSnapshot
    let updatedResolvedElementQuery: ResolvedElementQuery
    
    init(
        status: Status,
        updatedSnapshot: ElementSnapshot,
        updatedResolvedElementQuery: ResolvedElementQuery)
    {
        self.status = status
        self.updatedSnapshot = updatedSnapshot
        self.updatedResolvedElementQuery = updatedResolvedElementQuery
    }
}
