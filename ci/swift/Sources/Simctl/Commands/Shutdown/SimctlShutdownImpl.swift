import Bash

public final class SimctlShutdownImpl: SimctlShutdown {
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func shutdown(device: String) throws {
        _ = try bashExecutor.executeOrThrow(
            command: """
            xcrun simctl shutdown "\(device)"
            """
        )
    }
}
