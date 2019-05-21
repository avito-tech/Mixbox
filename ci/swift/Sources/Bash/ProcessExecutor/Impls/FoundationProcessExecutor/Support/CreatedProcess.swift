import Foundation

final class Process {
    let process = Foundation.Process()
    let stdoutPipe = Pipe()
    let stderrPipe = Pipe()
    
    init(
        executable: String,
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String])
    {
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
        process.launch()
        process.waitUntilExit()
        
        // TODO: Logging via abstraction
        // TODO: Logging during execution. Note: test with `xcrun simctl list -j`, when it was implemented,
        // it was failing to print > 4096, was making teamcity hang for several minutes, failed to store Data, etc.
        
        print("stdout:")
        FileHandle.standardOutput.write(stdoutPipe.getDataSynchronously())
        
        print("stderr:")
        FileHandle.standardError.write(stderrPipe.getDataSynchronously())
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
