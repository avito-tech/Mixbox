import XCTest
import Bash
import Foundation
import CiFoundation

final class BashExecutorFunctionalTests: XCTestCase {
    private var bashExecutor: BashExecutor {
        return ProcessExecutorBashExecutor(
            processExecutor: FoundationProcessExecutor(),
            environmentProvider: ProcessInfoEnvironmentProvider(
                processInfo: ProcessInfo.processInfo
            )
        )
    }
    
    func test___executeOrThrow___captures_stdout() {
        XCTAssertEqual(
            try bashExecutor.executeOrThrow(command: "echo; echo 1").stdout.utf8String().unwrapOrThrow(),
            "\n1\n"
        )
    }
    
    func test___executeAndReturnTrimmedOutputOrThrow___trims() {
        XCTAssertEqual(
            try bashExecutor.executeAndReturnTrimmedOutputOrThrow(command: "echo; echo 1"),
            "1"
        )
    }
    
    func test___executeOrThrow___doesnt_escape_characters___grave_accent() {
        XCTAssertEqual(
            try bashExecutor.executeOrThrow(command: "echo `echo 1`").stdout.utf8String().unwrapOrThrow(),
            "1\n"
        )
    }
    
    func test___executeOrThrow___doesnt_escape_characters___dollar() {
        XCTAssertEqual(
            try bashExecutor.executeOrThrow(command: "a=1; echo $a").stdout.utf8String().unwrapOrThrow(),
            "1\n"
        )
    }
    
    func test___executeOrThrow___doesnt_escape_characters___bang() {
        XCTAssertEqual(
            try bashExecutor.executeOrThrow(command: "set +H; echo !").stdout.utf8String().unwrapOrThrow(),
            "!\n"
        )
    }
    
    func test___executeOrThrow___throws() {
        XCTAssertThrowsError(
            try bashExecutor.executeOrThrow(command: "exit 1")
        )
    }
}
