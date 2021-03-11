public protocol BundlerBashCommandGenerator {
    func bashCommandRunningCommandBundler(
        arguments: [String])
        throws
        -> String
}
