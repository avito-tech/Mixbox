struct GatherFailuresResult<T> {
    enum BodyResult {
        case finished(T)
        case testFailedAndCannotBeContinued
        case caughtException(NSException)
    }
    
    let bodyResult: BodyResult
    let failures: [XcTestFailure]
}
