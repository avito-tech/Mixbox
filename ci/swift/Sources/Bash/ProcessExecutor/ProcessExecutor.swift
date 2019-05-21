public protocol ProcessExecutor: class {
    func execute(
        // Example: "/bin/ls"
        executable: String,
        // Example: ["-a"]
        arguments: [String],
        // Example: "/tmp". If nil is passed, current directory will not be changed.
        currentDirectory: String?,
        // Example: ["PATH": "/bin"]
        // Note that if you pass empty environment it will be empty, current environment will not be magically used
        environment: [String: String])
        -> ProcessResult
}
