import Bash
import Foundation

final class BashExecutorMock: BashExecutor {
    private(set) var executedCommands = [String]()
    private let bashResult: BashResult
    
    init(bashResult: BashResult) {
        self.bashResult = bashResult
    }
    
    convenience init(code: Int = 0, stdoutFile: String) throws {
        let bashResult = BashResult(
            code: code,
            stdout: BashOutput(
                processOutput: PlainProcessOutput(
                    data: try Data(
                        contentsOf: URL(fileURLWithPath: stdoutFile)
                    )
                )
            ),
            stderr: BashOutput(
                processOutput: PlainProcessOutput(
                    data: Data()
                )
            )
        )
        
        self.init(bashResult: bashResult)
    }
    
    func execute(
        command: String,
        currentDirectory: String?,
        environment: BashExecutorEnvironment,
        stdoutDataHandler: @escaping (Data) -> (),
        stderrDataHandler: @escaping (Data) -> ())
        throws
        -> BashResult
    {
        executedCommands.append(command)
        
        return bashResult
    }
}
