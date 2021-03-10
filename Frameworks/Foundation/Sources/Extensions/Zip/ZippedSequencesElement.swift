#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ZippedSequencesElement<First, Second> {
    public typealias UnzipFunction = (First?, Second?) throws -> (First, Second)
    
    public let first: First?
    public let second: Second?
    
    private let unzipFunction: UnzipFunction
    
    public init(
        first: First?,
        second: Second?,
        unzipFunction: @escaping UnzipFunction)
    {
        self.first = first
        self.second = second
        self.unzipFunction = unzipFunction
    }
    
    public func unzip() throws -> (First, Second) {
        return try unzipFunction(first, second)
    }
}

#endif
