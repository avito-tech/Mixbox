import Bash

public final class SimctlBootImpl: SimctlBoot {
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func boot(device: String) throws {
        _ = try bashExecutor.executeOrThrow(
            command: """
            xcrun simctl boot "\(device)"
            """
        )
    }
}
