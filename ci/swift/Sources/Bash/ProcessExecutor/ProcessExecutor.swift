public protocol ProcessExecutor: class {
    func execute(
        // Example: "/bin/ls"
        executable: String,
        // Example: ["-a"]
        arguments: [String],
        // Example: "/tmp". If nil is passed, current directory will not be changed.
        currentDirectory: String?,
        // Example: ["PATH": "/bin"]
        // Note: you can use EnvironmentProvider to get environment.
        environment: [String: String])
        -> ProcessResult
}
