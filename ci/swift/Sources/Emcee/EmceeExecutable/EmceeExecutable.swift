public protocol EmceeExecutable {
    func execute(command: String, arguments: [String]) throws
}
