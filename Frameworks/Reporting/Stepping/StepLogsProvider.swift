public protocol StepLogsProvider {
    var stepLogs: [StepLog] { get }
    
    func cleanLogs()
}
