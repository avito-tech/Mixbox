import MixboxReporting
import MixboxUiTestsFoundation

final class LogsAndFailuresMatcherBuilder {
    public let logs = ArrayPropertyMatcherBuilder<LogsAndFailures, StepLog, StepLogMatcherBuilder>(
        propertyName: "logs",
        propertyKeyPath: \LogsAndFailures.logs,
        matcherBuilder: StepLogMatcherBuilder()
    )
    
    public let failures = ArrayPropertyMatcherBuilder<LogsAndFailures, XcTestFailure, XcTestFailureMatcherBuilder>(
        propertyName: "failures",
        propertyKeyPath: \LogsAndFailures.failures,
        matcherBuilder: XcTestFailureMatcherBuilder()
    )
}
