public final class StdoutCiLogger: CiLogger {
    public init() {}
    
    public func logBlock(
        name: String,
        body: () throws -> ()
    ) rethrows {
        try body()
    }
    
    public func log(
        string: @autoclosure () -> String
    ) {
        print(string())
    }
}
