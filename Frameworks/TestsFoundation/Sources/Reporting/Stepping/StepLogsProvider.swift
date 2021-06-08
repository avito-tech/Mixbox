public protocol StepLogsProvider: AnyObject {
    var stepLogs: [StepLog] { get }
}
