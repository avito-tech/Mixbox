import Bash
import Foundation
import CiFoundation

public final class SimctlListImpl: SimctlList {
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func list() throws -> SimctlListResult {
        let result = try bashExecutor.executeOrThrow(command: "xcrun simctl list -j")
        
        return try readJson(data: result.stdout.data)
    }
}

private func readJson<T: Codable>(data: Data) throws -> T {
    do {
        return try JSONDecoder().decode(
            T.self,
            from: data
        )
    } catch {
        throw ErrorString("Error: \(error)")
    }
}
