public protocol ElementQuery: class {
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery
}
