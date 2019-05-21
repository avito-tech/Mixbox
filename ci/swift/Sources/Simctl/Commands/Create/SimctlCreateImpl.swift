import Foundation

import Bash

public final class SimctlCreateImpl: SimctlCreate {
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func create(
        name: String,
        deviceTypeIdentifier: String,
        runtimeId: String)
        throws
    {
        _ = try bashExecutor.executeOrThrow(
            command: """
            xcrun simctl create "\(name)" "\(deviceTypeIdentifier)" "\(runtimeId)"
            """
        )
    }
}
