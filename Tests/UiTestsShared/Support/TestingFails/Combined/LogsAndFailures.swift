import MixboxTestsFoundation

struct LogsAndFailuresWithBodyResult<T> {
    let bodyResult: GatherFailuresResult<T>.BodyResult
    let logs: [StepLog]
    let failures: [XcTestFailure]
    
    func withoutBodyResult() -> LogsAndFailures {
        return LogsAndFailures(
            logs: logs,
            failures: failures
        )
    }
}

struct LogsAndFailures {
    let logs: [StepLog]
    let failures: [XcTestFailure]
}
