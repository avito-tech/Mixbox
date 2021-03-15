import Git

public final class PodspecsPatcherImpl: PodspecsPatcher {
    private let repoRootProvider: RepoRootProvider
    
    public init(repoRootProvider: RepoRootProvider) {
        self.repoRootProvider = repoRootProvider
    }
    
    public func setMixboxFrameworkPodspecsVersion(
        _ version: Version)
        throws
    {
        try patchMixboxVersionRb(
            version: version
        )
    }
    
    public func resetMixboxFrameworkPodspecsVersion() throws {
        try patchMixboxVersionRb(
            version: Version(major: 0, minor: 0, patch: 1)
        )
    }
    
    private func patchMixboxVersionRb(version: Version) throws {
        try patchMixboxVersionRb(
            newContents:
            """
            $mixbox_version = '\(version.toString())'
            """
        )
    }
    
    private func patchMixboxVersionRb(newContents: String) throws {
        let path = try repoRootProvider.repoRootPath().appending(
            pathComponents: ["cocoapods", "mixbox_version.rb"]
        )
        
        try newContents.write(
            toFile: path,
            atomically: true,
            encoding: .utf8
        )
    }
}
