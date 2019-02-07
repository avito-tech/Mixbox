public protocol InteractionPerformerFactory {
    func performerForInteraction(
        shouldReportResultToObserver: Bool)
        -> InteractionPerformer
}
