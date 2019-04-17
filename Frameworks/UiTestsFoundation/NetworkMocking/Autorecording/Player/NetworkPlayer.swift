import MixboxFoundation

public protocol NetworkPlayer {
    // TODO: Function for starting and finalizing session!
    
    // Use `checkpoint` from extension in clients of this protocol.
    func checkpointImpl(
        id: String?,
        fileLine: RuntimeFileLine)
}

extension NetworkPlayer {
    public func checkpoint(
        id: String? = nil,
        file: StaticString = #file,
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
