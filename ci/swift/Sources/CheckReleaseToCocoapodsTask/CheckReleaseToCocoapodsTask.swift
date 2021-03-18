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
    private let cocoapodsValidationPatcher: CocoapodsValidationPatcher
    private let mixboxPodspecsValidator: MixboxPodspecsValidator
    private let mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider
    
    public init(
        headCommitHashProvider: HeadCommitHashProvider,
        nextReleaseVersionProvider: NextReleaseVersionProvider,
        gitTagAdder: GitTagAdder,
        gitTagDeleter: GitTagDeleter,
        cocoapodsValidationPatcher: CocoapodsValidationPatcher,
        mixboxPodspecsValidator: MixboxPodspecsValidator,
        mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider)
    {
        self.headCommitHashProvider = headCommitHashProvider
        self.nextReleaseVersionProvider = nextReleaseVersionProvider
        self.gitTagAdder = gitTagAdder
        self.gitTagDeleter = gitTagDeleter
        self.cocoapodsValidationPatcher = cocoapodsValidationPatcher
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
            print("Will delete local tag")
            try? gitTagDeleter.deleteLocalTag(
                tagName: versionString
            )
        }
        
        print("Will set up local tag")
        try gitTagAdder.addTag(
            tagName: versionString,
            commitHash: commitHashToRelease
        )
        
        // Patch cocoapods
        
        defer {
            print("Will reset validation code in Cocoapods")
            try? cocoapodsValidationPatcher.setPodspecValidationEnabled(true)
        }

        print("Will disable validation code in Cocoapods")
        try cocoapodsValidationPatcher.setPodspecValidationEnabled(false)
        
        // Run validation
        
        print("Will validate Mixbox podspecs")
        try mixboxPodspecsValidator.validateMixboxPodspecs()
    }
}
