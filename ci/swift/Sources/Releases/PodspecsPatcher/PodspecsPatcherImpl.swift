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
        let newContents =
        """
        $mixbox_version = '\(version.toString())'
        """
        
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
