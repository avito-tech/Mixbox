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
    public let name = "CheckReleaseToCocoapodsTask"
    
    private let headCommitHashProvider: HeadCommitHashProvider
    private let nextReleaseVersionProvider: NextReleaseVersionProvider
    private let gitTagAdder: GitTagAdder
    private let gitTagDeleter: GitTagDeleter
    private let podspecsPatcher: PodspecsPatcher
    private let mixboxPodspecsValidator: MixboxPodspecsValidator
    private let mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider
    
    public init(
        headCommitHashProvider: HeadCommitHashProvider,
        nextReleaseVersionProvider: NextReleaseVersionProvider,
        gitTagAdder: GitTagAdder,
        gitTagDeleter: GitTagDeleter,
        podspecsPatcher: PodspecsPatcher,
        mixboxPodspecsValidator: MixboxPodspecsValidator,
        mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider)
    {
        self.headCommitHashProvider = headCommitHashProvider
        self.nextReleaseVersionProvider = nextReleaseVersionProvider
        self.gitTagAdder = gitTagAdder
        self.gitTagDeleter = gitTagDeleter
        self.podspecsPatcher = podspecsPatcher
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
        
        // Add tag
        
        defer {
            try? gitTagDeleter.deleteLocalTag(
                tagName: versionString
            )
        }
        
        try gitTagAdder.addTag(
            tagName: versionString,
            commitHash: commitHashToRelease
        )
        
        // Set version
            
        defer {
            try? podspecsPatcher.resetMixboxFrameworkPodspecsVersion()
        }
        
        try podspecsPatcher.setMixboxFrameworkPodspecsVersion(version)
        
        // Run validation
        
        try mixboxPodspecsValidator.validateMixboxPodspecs()
    }
}
