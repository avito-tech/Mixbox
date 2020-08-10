import Foundation
import XCTest

// Stops current test with failure, but does not affect other tests.
public final class UnavoidableFailure {
    public static func fail(
        _ message: String = "",
        file: StaticString = #file,
        line: UInt = #line)
        -> Never
    {
        AutomaticCurrentTestCaseProvider().currentTestCase()?.continueAfterFailure = false
        XCTFail(message, file: file, line: line)
        NSException(name: UnavoidableFailureException, reason: message).raise()
        
        // To produce `Never` return value. Note that it will not be executed after
        // raising an exception on the previous line
        fatalError(message)
    }
    
    public static func doOrFail<T>(
        file: StaticString = #file,
        line: UInt = #line,
        body: () throws -> T)
        -> T
    {
        do {
            return try body()
        } catch {
            UnavoidableFailure.fail(
                "\(error)",
                file: file,
                line: line
            )
        }
    }
    
    static let UnavoidableFailureException = NSExceptionName(rawValue: "UnavoidableFailureException")
    
    private init() {}
}
