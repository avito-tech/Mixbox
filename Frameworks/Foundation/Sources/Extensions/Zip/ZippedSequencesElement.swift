#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

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
