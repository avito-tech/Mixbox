public protocol GitRevListProvider {
    func revList(
        repoRoot: String,
        branch: String)
        throws
        -> [String]
}
