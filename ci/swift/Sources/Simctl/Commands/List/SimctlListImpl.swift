import Bash
import Foundation
import CiFoundation

public final class SimctlListImpl: SimctlList {
    private let bashExecutor: BashExecutor
    private let temporaryFileProvider: TemporaryFileProvider
    
    public init(
        bashExecutor: BashExecutor,
        temporaryFileProvider: TemporaryFileProvider)
    {
        self.bashExecutor = bashExecutor
        self.temporaryFileProvider = temporaryFileProvider
    }
    
    public func list() throws -> SimctlListResult {
        // There is a bug in this project, something with BashExecutor/ProcessExecutor.
        // It hangs if output of `xcrun simctl list -j` is read. But not if it is stored to file.
        // I can not reproduce it on a local machine.
        // TODO: Check if the bug is present, I am not sure.
        //
        let temporaryFile = temporaryFileProvider.temporaryFilePath()
        _ = try bashExecutor.executeOrThrow(
            command:
            """
            xcrun simctl list -j > "\(temporaryFile)"
            """
        )
        
        let data = try Data(contentsOf: URL(fileURLWithPath: temporaryFile))
        
        return try readJson(data: data)
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
