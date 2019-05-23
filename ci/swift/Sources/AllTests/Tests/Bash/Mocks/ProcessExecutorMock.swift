import Bash
import Foundation

final class ProcessExecutorMock: ProcessExecutor {
    struct Call {
        let executable: String
        let arguments: [String]
        let currentDirectory: String?
        let environment: [String: String]
    }
    
    private(set) var calls = [Call]()
    private let result: ProcessResult
    
    init(result: ProcessResult) {
        self.result = result
    }
    
    func execute(
        executable: String,
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String],
        stdoutDataHandler: @escaping (Data) -> (),
        stderrDataHandler: @escaping (Data) -> ())
        -> ProcessResult
    {
        calls.append(
            Call(
                executable: executable,
                arguments: arguments,
                currentDirectory: currentDirectory,
                environment: environment
            )
        )
        
        return result
    }
}
