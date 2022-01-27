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
import Releases

public final class CheckReleaseToCocoapodsTask: LocalTask {
    private let headCommitHashProvider: HeadCommitHashProvider
    private let nextReleaseVersionProvider: NextReleaseVersionProvider
    private let gitTagAdder: GitTagAdder
    private let gitTagDeleter: GitTagDeleter
    private let mixboxPodspecsValidator: MixboxPodspecsValidator
    private let mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider
    
    public init(
        headCommitHashProvider: HeadCommitHashProvider,
        nextReleaseVersionProvider: NextReleaseVersionProvider,
        gitTagAdder: GitTagAdder,
        gitTagDeleter: GitTagDeleter,
        mixboxPodspecsValidator: MixboxPodspecsValidator,
        mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider)
    {
        self.headCommitHashProvider = headCommitHashProvider
        self.nextReleaseVersionProvider = nextReleaseVersionProvider
        self.gitTagAdder = gitTagAdder
        self.gitTagDeleter = gitTagDeleter
        self.mixboxPodspecsValidator = mixboxPodspecsValidator
        self.mixboxReleaseSettingsProvider = mixboxReleaseSettingsProvider
    }
    
    public func execute() throws {
        let commitHashToRelease = try headCommitHashProvider.headCommitHash()
        
        let version = try nextReleaseVersionProvider.nextReleaseVersion(
            majorVersion: mixboxReleaseSettingsProvider.majorVersion,
            minorVersion: mixboxReleaseSettingsProvider.minorVersion,
            commitHashToRelease: commitHashToRelease,
            releaseBranchName: "HEAD"
        )
        
        let versionString = version.toString()
        
        defer { try? gitTagDeleter.deleteLocalTag(tagName: versionString) }
        try gitTagAdder.addTag(tagName: versionString, commitHash: commitHashToRelease)
        
        try mixboxPodspecsValidator.validateMixboxPodspecs()
    }
}
