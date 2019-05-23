public protocol EmceeDumpCommand {
    func dump(
        arguments: EmceeDumpCommandArguments)
        throws
        -> RuntimeDump
}

// Delegation

public protocol EmceeDumpCommandHolder {
    var emceeDumpCommand: EmceeDumpCommand { get }
}

extension EmceeDumpCommand where Self: EmceeDumpCommandHolder {
    public func dump(
        arguments: EmceeDumpCommandArguments)
        throws
        -> RuntimeDump
    {
        return try emceeDumpCommand.dump(
            arguments: arguments
        )
    }
}
