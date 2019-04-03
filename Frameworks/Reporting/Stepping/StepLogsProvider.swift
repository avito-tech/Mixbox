public protocol StepLogsProvider: class {
    var stepLogs: [StepLog] { get }
    
    func cleanLogs()
}
