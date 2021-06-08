public protocol ElementResolver: AnyObject {
    func resolveElement() throws -> ResolvedElementQuery
}
