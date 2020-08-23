import Foundation

public protocol ProcessExecutor: class {
    func execute(
        // Example: ["/bin/ls", "-a"]
        arguments: [String],
        // Example: "/tmp". If nil is passed, current directory will not be changed.
        currentDirectory: String?,
        // Example: ["PATH": "/bin"]
        // Note: you can use EnvironmentProvider to get environment.
        environment: [String: String],
        stdoutDataHandler: @escaping (Data) -> (),
        stderrDataHandler: @escaping (Data) -> ())
        throws
        -> ProcessResult
}
