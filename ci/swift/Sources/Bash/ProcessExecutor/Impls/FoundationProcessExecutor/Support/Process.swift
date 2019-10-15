import Foundation

final class Process {
    let process = Foundation.Process()
    let stdoutPipe: Pipe
    let stderrPipe: Pipe
    
    init(
        executable: String,
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String],
        stdoutDataHandler: @escaping (Data) -> (),
        stderrDataHandler: @escaping (Data) -> ())
    {
        stdoutPipe = Pipe(dataHandler: stdoutDataHandler)
        stderrPipe = Pipe(dataHandler: stderrDataHandler)
        
        // This is probably set up by `execve` and thus required
        process.launchPath = executable
        process.arguments = arguments
        process.environment = environment
        
        // This is probably set up  by `chdir` and thus optional
        if let currentDirectory = currentDirectory {
            process.currentDirectoryPath = currentDirectory
        }
        
        process.standardOutput = stdoutPipe.pipe
        process.standardError = stderrPipe.pipe
    }
    
    func execute() {
        // TODO: Catch Objective-C exceptions. How to test: try to execute random binary file (not executable).
        process.launch()
        process.waitUntilExit()
    }
    
    func result() -> ProcessResult {
        return ProcessResult(
            code: Int(process.terminationStatus),
            stdout: LazyProcessOutput(
                pipe: stdoutPipe
            ),
            stderr: LazyProcessOutput(
                pipe: stderrPipe
            )
        )
    }
}
