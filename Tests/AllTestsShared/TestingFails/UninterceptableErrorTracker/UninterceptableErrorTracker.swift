import XCTest
import MixboxFoundation
import MixboxTestsFoundation

// Because tests in this project test failures by intercepting them,
// some failures can be suppressed. This can lead to false-positive tests.
//
// Example:
//
// ```
// assertFails {
//     let someArg = someOtherVariable.array.onlyOrFail() // this is just testing code, it is not expected to fail
//
//     utilityBeingTested.soSomethingOrFailTests(someArg) // this is expected to fail test
// }
// ```
//
// Some internal error causes a failure, but test is green, because every failure is
// intecepted and `assertFails` expects that failure occurs.
//
// `UninterceptableErrorTracker` can solve this:
//
// ```
// assertFails { [uninterceptableErrorTracker] in
//     // this is just testing code, it is not expected to fail
//     let someArg = uninterceptableErrorTracker.doOrFail {
//          someOtherVariable.array.mb_only.unwrapOrThrow()
//     }
//
//     utilityBeingTested.soSomethingOrFailTests(someArg) // this is expected to fail test
// }
// ```
//
protocol UninterceptableErrorTracker {
    func track(uninterceptableError: UninterceptableError)
}

extension UninterceptableErrorTracker {
    func trackAndFail(uninterceptableError: UninterceptableError) -> Never {
        track(uninterceptableError: uninterceptableError)
        
        UnavoidableFailure.fail(
            message: "\(uninterceptableError.error)",
            fileLine: uninterceptableError.fileLine
        )
    }
    
    func track(error: Error, file: StaticString = #filePath, line: UInt = #line) {
        track(
            uninterceptableError: UninterceptableError(
                error: error,
                fileLine: FileLine(
                    file: file,
                    line: line
                )
            )
        )
    }
    
    func trackAndFail(error: Error, file: StaticString = #filePath, line: UInt = #line) -> Never {
        trackAndFail(
            uninterceptableError: UninterceptableError(
                error: error,
                fileLine: FileLine(
                    file: file,
                    line: line
                )
            )
        )
    }
    
    func doOrFail<T>(
        file: StaticString = #filePath,
        line: UInt = #line,
        body: () throws -> T)
        -> T
    {
        do {
            return try body()
        } catch {
            trackAndFail(
                uninterceptableError: UninterceptableError(
                    error: error,
                    fileLine: FileLine(
                        file: file,
                        line: line
                    )
                )
            )
        }
    }
}
