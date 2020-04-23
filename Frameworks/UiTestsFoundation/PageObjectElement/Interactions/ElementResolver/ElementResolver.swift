public protocol ElementResolver: class {
    func resolveElement() throws -> ResolvedElementQuery
}
