public protocol InteractionObserver {
    func interactionDidStart(
        interactionDescription: InteractionDescription)
    
    func interactionDidStop(
        interactionDescription: InteractionDescription,
        result: InteractionResult)
}
