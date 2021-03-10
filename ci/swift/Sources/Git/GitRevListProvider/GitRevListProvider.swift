public protocol GitRevListProvider {
    func revList(
        branch: String)
        throws
        -> [String]
}
