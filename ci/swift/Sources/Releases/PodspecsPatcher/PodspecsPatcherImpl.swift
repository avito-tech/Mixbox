import Git

public final class PodspecsPatcherImpl: PodspecsPatcher {
    private let repoRootProvider: RepoRootProvider
    
    public init(repoRootProvider: RepoRootProvider) {
        self.repoRootProvider = repoRootProvider
    }
    
    public func setMixboxPodspecsSource(
        _ source: String)
        throws
    {
        try patchMixboxPodspecsSourceRb(
            newContents:
            """
            $mixbox_podspecs_source = '\(source)'
            """
        )
    }
    
    public func resetMixboxPodspecsSource() throws {
        try setMixboxPodspecsSource(
            "https://github.com/avito-tech/Mixbox.git"
        )
    }
    
    private func patchMixboxPodspecsSourceRb(newContents: String) throws {
        let path = try repoRootProvider.repoRootPath().appending(
            pathComponents: ["cocoapods", "mixbox_podspecs_source.rb"]
        )
        
        try newContents.write(
            toFile: path,
            atomically: true,
            encoding: .utf8
        )
    }
}
