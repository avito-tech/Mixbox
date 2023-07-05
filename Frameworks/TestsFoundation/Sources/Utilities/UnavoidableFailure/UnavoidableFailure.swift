import Foundation
import XCTest
import MixboxFoundation

// Stops current test with failure, but does not affect other tests.
public final class UnavoidableFailure {
    public static func fail(
        _ message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line)
        -> Never
    {
        fail(
            message: message,
            fileLine: FileLine(
                file: file,
                line: line
            )
        )
    }
    
    public static func fail(
        message: String,
        fileLine: FileLine)
        -> Never
    {
        AutomaticCurrentTestCaseProvider().currentTestCase()?.continueAfterFailure = false
        XCTFail(message, file: fileLine.file, line: fileLine.line)
        NSException(name: unavoidableFailureException, reason: message).raise()
        
        // To produce `Never` return value. Note that it will not be executed after
        // raising an exception on the previous line
        fatalError(message)
    }
    
    public static func doOrFail<T>(
        file: StaticString = #filePath,
        line: UInt = #line,
        body: () throws -> T)
        -> T
    {
        return doOrFail(
            fileLine: FileLine(
                file: file,
                line: line
            ),
            body: body
        )
    }
    
    public static func doOrFail<T>(
        fileLine: FileLine,
        body: () throws -> T)
        -> T
    {
        do {
            return try body()
        } catch {
            UnavoidableFailure.fail(
                message: "\(error)",
                fileLine: fileLine
            )
        }
    }
    
    private static var unavoidableFailureException: NSExceptionName {
        NSExceptionName(rawValue: "UnavoidableFailureException")
    }
    
    private init() {}
}
