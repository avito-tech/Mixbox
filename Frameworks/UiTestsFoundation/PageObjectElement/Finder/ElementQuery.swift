public protocol ElementQuery {
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery
}
