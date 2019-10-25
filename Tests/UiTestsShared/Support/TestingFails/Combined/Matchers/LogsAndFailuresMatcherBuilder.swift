import MixboxTestsFoundation
import MixboxUiTestsFoundation

final class LogsAndFailuresMatcherBuilder {
    let logs = ArrayPropertyMatcherBuilder<LogsAndFailures, StepLog, StepLogMatcherBuilder>(
        propertyName: "logs",
        propertyKeyPath: \LogsAndFailures.logs,
        matcherBuilder: StepLogMatcherBuilder()
    )
    
    let failures = ArrayPropertyMatcherBuilder<LogsAndFailures, XcTestFailure, XcTestFailureMatcherBuilder>(
        propertyName: "failures",
        propertyKeyPath: \LogsAndFailures.failures,
        matcherBuilder: XcTestFailureMatcherBuilder()
    )
}
