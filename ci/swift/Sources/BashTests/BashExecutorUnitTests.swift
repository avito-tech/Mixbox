import XCTest
import Bash

final class BashExecutorUnitTests: XCTestCase {
    func test___execute___passes_arguments_to_ProcessExecutor() {
        // Given
        
        let stdout = Data(repeating: 11, count: 111)
        let stderr = Data(repeating: 22, count: 222)
        
        let processExecutor = ProcessExecutorMock(
            result: ProcessResult(
                code: 33,
                stdout: PlainProcessOutput(data: stdout),
                stderr: PlainProcessOutput(data: stderr)
            )
        )
        
        let bashExecutor: BashExecutor = ProcessExecutorBashExecutor(
            processExecutor: processExecutor,
            environmentProvider: EnvironmentProviderMock(environment: [:])
        )
        
        // When
        
        let command =
        """
        !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~
        """
        
        let result = bashExecutor.execute(
            command: command,
            currentDirectory: "a",
            environment: ["b": "c"]
        )
        
        // Then
        
        guard let call = processExecutor.calls.first else { return XCTFail("No calls") }
        
        XCTAssertEqual(call.executable, "/bin/bash")
        XCTAssertEqual(call.arguments, ["-l", "-c", command])
        XCTAssertEqual(call.currentDirectory, "a")
        XCTAssertEqual(call.environment, ["b": "c"])
        XCTAssertEqual(result.code, 33)
        XCTAssertEqual(result.stdout.data, stdout)
        XCTAssertEqual(result.stderr.data, stderr)
    }
    
    func test___execute___uses_environmentProvider___when_environment_is_not_passed() {
        // Given
        
        let processExecutor = ProcessExecutorMock(
            result: anyProcessResult()
        )
        
        let bashExecutor: BashExecutor = ProcessExecutorBashExecutor(
            processExecutor: processExecutor,
            environmentProvider: EnvironmentProviderMock(environment: ["a": "b"])
        )
        
        // When
        
        let result = bashExecutor.execute(
            command: anyString(),
            currentDirectory: anyString(),
            environment: nil
        )
        
        // Then
        
        guard let call = processExecutor.calls.first else { return XCTFail("No calls") }
        
        XCTAssertEqual(call.environment, ["a": "b"])
    }
    
    private func anyProcessOutput() -> ProcessOutput {
        return PlainProcessOutput(data: Data())
    }
    
    private func anyString() -> String {
        return ""
    }
    
    private func anyProcessResult() -> ProcessResult {
        return ProcessResult(
            code: anyInt(),
            stdout: anyProcessOutput(),
            stderr: anyProcessOutput()
        )
    }
    
    private func anyInt() -> Int {
        return 0
    }
}
