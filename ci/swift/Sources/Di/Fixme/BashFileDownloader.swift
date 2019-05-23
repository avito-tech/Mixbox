import Bash
import Foundation
import CiFoundation

public final class BashFileDownloader: FileDownloader {
    private let temporaryFileProvider: TemporaryFileProvider
    private let bashExecutor: BashExecutor
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        bashExecutor: BashExecutor)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.bashExecutor = bashExecutor
    }
    
    public func download(url: URL) throws -> String {
        let file = temporaryFileProvider.temporaryFilePath()
        
        try _ = bashExecutor.executeOrThrow(
            command:
            """
            set -o pipefail
            curl "\(url)" -o "\(file)" | cat
            """
        )
        
        return file
    }
}
