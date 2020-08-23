import Bash

public protocol BundledProcessExecutor {
    func execute(
        // Example: ["pod", "install"]
        arguments: [String],
        // Example: "/tmp". If nil is passed, current directory will not be changed.
        currentDirectory: String?,
        // Example: ["PATH": "/bin"]. If nil is passed, `environmentProvider.environment` will be used.
        environment: [String: String]?)
        throws
        -> ProcessResult
}
