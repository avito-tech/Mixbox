import MixboxFoundation
import MixboxTestsFoundation

final class UnwrapOrThrowTests: TestCase {
    private let nilValue: Int? = nil
    private let file: StaticString = "x.swift"
    private let line: UInt = 42
    private var fileLine: FileLine {
        FileLine(file: file, line: line)
    }
    
    func test___unwrapOrThrow___throws_correct_exception___if_called_with_default_arguments() {
        assertThrows(error: "Found nil when unwrapping optional at x.swift:42") {
            _ = try nilValue.unwrapOrThrow(file: file, line: line)
        }
    }
    
    func test___unwrapOrThrow___throws_correct_exception___if_called_with_autoclosures() {
        assertThrows(error: "message") {
            _ = try nilValue.unwrapOrThrow(
                message: "message"
            )
        }
        
        assertThrows(error: "error") {
            _ = try nilValue.unwrapOrThrow(
                error: ErrorString("error")
            )
        }
    }
    
    func test___unwrapOrThrow___throws_correct_exception___if_called_with_closures() {
        assertThrows(error: "error,file:x.swift,line:42") {
            _ = try nilValue.unwrapOrThrow(
                error: { fileLine in
                    ErrorString("error,file:\(fileLine.file),line:\(fileLine.line)")
                },
                file: file,
                line: line
            )
        }
        assertThrows(error: "message,file:x.swift,line:42") {
            _ = try nilValue.unwrapOrThrow(
                message: { fileLine in
                    "message,file:\(fileLine.file),line:\(fileLine.line)"
                },
                file: file,
                line: line
            )
        }
    }
}
