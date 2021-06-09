import CiFoundation

public final class CocoapodsTrunkInfoImpl: CocoapodsTrunkInfo {
    private let cocoapodsTrunkCommandExecutor: CocoapodsTrunkCommandExecutor
    private let cocoapodsTrunkInfoOutputParser: CocoapodsTrunkInfoOutputParser
    
    public init(
        cocoapodsTrunkCommandExecutor: CocoapodsTrunkCommandExecutor,
        cocoapodsTrunkInfoOutputParser: CocoapodsTrunkInfoOutputParser)
    {
        self.cocoapodsTrunkCommandExecutor = cocoapodsTrunkCommandExecutor
        self.cocoapodsTrunkInfoOutputParser = cocoapodsTrunkInfoOutputParser
    }
    
    public func info(
        podName: String)
        throws
        -> CocoapodsTrunkInfoResult
    {
        let result = try cocoapodsTrunkCommandExecutor.execute(
            arguments: [
                "info",
                podName
            ],
            shouldThrowOnNonzeroExitCode: false
        )
        
        return try cocoapodsTrunkInfoOutputParser.parse(
            output: result.stdout.trimmedUtf8String().unwrapOrThrow()
        )
    }
}
