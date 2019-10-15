import XCTest
import Bash

final class BashExecutorUnitTests: XCTestCase {
    // Note: this test can be split
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
        
        do {
            let result = try bashExecutor.execute(
                command: command,
                currentDirectory: "a",
                environment: .custom(["b": "c"]),
                stdoutDataHandler: { _ in },
                stderrDataHandler: { _ in }
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
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test___execute___uses_environmentProvider___if_envitonment_is_current() {
        // Given
        
        let processExecutor = ProcessExecutorMock(
            result: anyProcessResult()
        )
        
        let bashExecutor: BashExecutor = ProcessExecutorBashExecutor(
            processExecutor: processExecutor,
            environmentProvider: EnvironmentProviderMock(environment: ["a": "b"])
        )
        
        // When
        
        do {
            _ = try bashExecutor.execute(
                command: anyString(),
                currentDirectory: anyString(),
                environment: .current,
                stdoutDataHandler: { _ in },
                stderrDataHandler: { _ in }
            )
        } catch {
            XCTFail("\(error)")
        }
        
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
