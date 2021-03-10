public protocol HeadCommitHashProvider {
    func headCommitHash()
        throws
        -> String
}
