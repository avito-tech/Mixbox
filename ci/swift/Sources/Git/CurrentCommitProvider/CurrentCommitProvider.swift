public protocol CurrentCommitProvider {
    func currentCommit(
        repoRoot: String)
        throws
        -> String
}
