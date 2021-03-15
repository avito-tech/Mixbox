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
    private let mixboxPodspecsValidator: MixboxPodspecsValidator
    private let mixboxPodspecsPusher: MixboxPodspecsPusher
    
    public init(
        headCommitHashProvider: HeadCommitHashProvider,
        nextReleaseVersionProvider: NextReleaseVersionProvider,
        beforeReleaseTagsSetter: BeforeReleaseTagsSetter,
        podspecsPatcher: PodspecsPatcher,
        mixboxPodspecsValidator: MixboxPodspecsValidator,
        mixboxPodspecsPusher: MixboxPodspecsPusher)
    {
        self.headCommitHashProvider = headCommitHashProvider
        self.nextReleaseVersionProvider = nextReleaseVersionProvider
        self.beforeReleaseTagsSetter = beforeReleaseTagsSetter
        self.podspecsPatcher = podspecsPatcher
        self.mixboxPodspecsValidator = mixboxPodspecsValidator
        self.mixboxPodspecsPusher = mixboxPodspecsPusher
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
        
        try mixboxPodspecsValidator.validateMixboxPodspecs()
        try mixboxPodspecsPusher.pushMixboxPodspecs()
        
        setUpTagsAfterRelease(version: version)
    }
    
    private func setUpTagsAfterRelease(version: Version) {
        // TBD.
        // Will finalize tags (e.g. remove marker tag that
        // says that release is unfinished)
    }
}
