import MixboxFoundation

public protocol NetworkPlayer: class {
    // TODO: Function for starting and finalizing session!
    
    // Use `checkpoint` from extension in clients of this protocol.
    func checkpointImpl(
        id: String?,
        fileLine: RuntimeFileLine)
}

extension NetworkPlayer {
    public func checkpoint(
        id: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        checkpointImpl(
            id: id,
            fileLine: RuntimeFileLine(
                file: file,
                line: line
            )
        )
    }
}
