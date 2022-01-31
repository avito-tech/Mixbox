import Bash

public final class SimctlShutdownImpl: SimctlShutdown {
    private let simctlExecutor: SimctlExecutor
    
    public init(
        simctlExecutor: SimctlExecutor)
    {
        self.simctlExecutor = simctlExecutor
    }
    
    public func shutdown(device: String) throws {
        _ = try simctlExecutor.execute(
            arguments: ["shutdown", device]
        )
    }
}
