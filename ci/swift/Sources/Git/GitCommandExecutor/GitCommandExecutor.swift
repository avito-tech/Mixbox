public protocol GitCommandExecutor {
    func execute(
        arguments: [String])
        throws
        -> String
}
