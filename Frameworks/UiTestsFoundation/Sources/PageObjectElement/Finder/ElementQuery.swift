public protocol ElementQuery: AnyObject {
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery
}
