import Bash
import Foundation
import CiFoundation

public final class SimctlListImpl: SimctlList {
    private let simctlExecutor: SimctlExecutor
    
    public init(
        simctlExecutor: SimctlExecutor)
    {
        self.simctlExecutor = simctlExecutor
    }
    
    public func list() throws -> SimctlListResult {
        let result = try simctlExecutor.execute(
            arguments: ["list", "-j"]
        )
        
        return try readJson(data: result.stdout.data)
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
}
