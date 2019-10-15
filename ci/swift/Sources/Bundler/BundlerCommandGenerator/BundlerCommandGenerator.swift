// This class doesn't execute anything, because we use xcpretty in bash pipes to generate JUnit reports.
// If we can rewrite JUnit generation, we can rewrite working with `bundler` so it can execute commands
// instead of forming bash command.
public protocol BundlerCommandGenerator {
    func bundlerCommand(command: String) throws -> String
}
