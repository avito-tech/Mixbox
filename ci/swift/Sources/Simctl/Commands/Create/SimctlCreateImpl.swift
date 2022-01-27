import Foundation

import Bash

public final class SimctlCreateImpl: SimctlCreate {
    private let simctlExecutor: SimctlExecutor
    
    public init(
        simctlExecutor: SimctlExecutor)
    {
        self.simctlExecutor = simctlExecutor
    }
    
    public func create(
        name: String,
        deviceTypeIdentifier: String,
        runtimeId: String
    ) throws {
        _ = try simctlExecutor.execute(
            arguments: ["create", name, deviceTypeIdentifier, runtimeId]
        )
    }
}
