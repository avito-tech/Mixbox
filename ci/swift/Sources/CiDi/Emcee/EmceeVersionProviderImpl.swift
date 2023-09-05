import Emcee
import Git
import FileSystem
import PathLib

public final class EmceeVersionProviderImpl: EmceeVersionProvider {
    private let repoRootProvider: RepoRootProvider
    private let fileReader: FileReader
    
    public init(
        repoRootProvider: RepoRootProvider,
        fileReader: FileReader
    ) {
        self.repoRootProvider = repoRootProvider
        self.fileReader = fileReader
    }
    
    public func emceeVersion() throws -> String {
        let emceeCommitHash = try fileReader.string(
            filePath: AbsolutePath(repoRootProvider.repoRootPath()).appending("ci/swift/.emceeversion")
        ).trimmingCharacters(in: .whitespacesAndNewlines)
        
        return String(emceeCommitHash.prefix(7))
    }
}
