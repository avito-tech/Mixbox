import Bash

public final class SimctlBootImpl: SimctlBoot {
    private let simctlExecutor: SimctlExecutor
    
    public init(
        simctlExecutor: SimctlExecutor)
    {
        self.simctlExecutor = simctlExecutor
    }
    
    public func boot(device: String) throws {
        _ = try simctlExecutor.execute(
            arguments: ["boot", device]
        )
    }
}
