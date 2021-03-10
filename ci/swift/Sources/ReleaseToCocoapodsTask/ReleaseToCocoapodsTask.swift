import Bash
import Foundation
import CiFoundation
import Tasks
import SingletonHell
import Emcee
import Destinations
import Xcodebuild
import Bundler
import Git

public final class ReleaseToCocoapodsTask: LocalTask {
    public let name = "ReleaseToCocoapodsTask"
    
    private let headCommitHashProvider: HeadCommitHashProvider
    private let nextReleaseVersionProvider: NextReleaseVersionProvider
    private let beforeReleaseTagsSetter: BeforeReleaseTagsSetter
    private let podspecsPatcher: PodspecsPatcher
    
    public init(
        headCommitHashProvider: HeadCommitHashProvider,
        nextReleaseVersionProvider: NextReleaseVersionProvider,
        beforeReleaseTagsSetter: BeforeReleaseTagsSetter,
        podspecsPatcher: PodspecsPatcher)
    {
        self.headCommitHashProvider = headCommitHashProvider
        self.nextReleaseVersionProvider = nextReleaseVersionProvider
        self.beforeReleaseTagsSetter = beforeReleaseTagsSetter
        self.podspecsPatcher = podspecsPatcher
    }
    
    public func execute() throws {
        let commitHashToRelease = try headCommitHashProvider.headCommitHash()
        
        let version = try nextReleaseVersionProvider.nextReleaseVersion(
            commitHashToRelease: commitHashToRelease
        )
        
        try beforeReleaseTagsSetter.setUpTagsBeforeRelease(
            version: version,
            commitHash: commitHashToRelease,
            remote: "origin"
        )
        
        try podspecsPatcher.setMixboxFrameworkPodspecsVersion(version)
        
        validatePodspecs()
        pushPodspecs()
        
        setUpTagsAfterRelease(version: version)
    }
    
    private func validatePodspecs() {
        // TBD.
        // Validate all podspecs normally (using cocoapods).
        // This will ensure that everything can be pushed atomically later.
        // For example, if we just use push with validation,
        // and something will not pass validation, the release
        // will not be atomic (some pods will be released and some
        // will not).
    }
    
    private func pushPodspecs() {
        // TBD.
        // Push podspecs using cocoapods. We want to
        // skip validation of podspecs (because we should do it
        // earlier and for all pods at once), it is not
        // possible in cocoapods without hacking it.
    }
    
    private func setUpTagsAfterRelease(version: Version) {
        // TBD.
        // Will finalize tags (e.g. remove marker tag that
        // says that release is unfinished)
    }
}
