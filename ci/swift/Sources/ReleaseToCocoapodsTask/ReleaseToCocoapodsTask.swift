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

public final class ReleaseToCocoapodsTask: LocalTask {
    public let name = "ReleaseToCocoapodsTask"
    
    private let headCommitHashProvider: HeadCommitHashProvider
    private let nextReleaseVersionProvider: NextReleaseVersionProvider
    private let beforeReleaseTagsSetter: BeforeReleaseTagsSetter
    private let cocoapodsValidationPatcher: CocoapodsValidationPatcher
    private let mixboxPodspecsValidator: MixboxPodspecsValidator
    private let mixboxPodspecsPusher: MixboxPodspecsPusher
    private let mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider
    
    public init(
        headCommitHashProvider: HeadCommitHashProvider,
        nextReleaseVersionProvider: NextReleaseVersionProvider,
        beforeReleaseTagsSetter: BeforeReleaseTagsSetter,
        cocoapodsValidationPatcher: CocoapodsValidationPatcher,
        mixboxPodspecsValidator: MixboxPodspecsValidator,
        mixboxPodspecsPusher: MixboxPodspecsPusher,
        mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider)
    {
        self.headCommitHashProvider = headCommitHashProvider
        self.nextReleaseVersionProvider = nextReleaseVersionProvider
        self.beforeReleaseTagsSetter = beforeReleaseTagsSetter
        self.cocoapodsValidationPatcher = cocoapodsValidationPatcher
        self.mixboxPodspecsValidator = mixboxPodspecsValidator
        self.mixboxPodspecsPusher = mixboxPodspecsPusher
        self.mixboxReleaseSettingsProvider = mixboxReleaseSettingsProvider
    }
    
    public func execute() throws {
        let commitHashToRelease = try headCommitHashProvider.headCommitHash()
        
        let version = try nextReleaseVersionProvider.nextReleaseVersion(
            majorVersion: mixboxReleaseSettingsProvider.majorVersion,
            minorVersion: mixboxReleaseSettingsProvider.minorVersion,
            commitHashToRelease: commitHashToRelease,
            releaseBranchName: mixboxReleaseSettingsProvider.releaseBranchFullName
        )
        
        try beforeReleaseTagsSetter.setUpTagsBeforeRelease(
            version: version,
            commitHash: commitHashToRelease,
            remote: mixboxReleaseSettingsProvider.releaseRemoteName
        )
        
        // Patch cocoapods
            
        defer {
            print("Will reset validation code in Cocoapods")
            try? cocoapodsValidationPatcher.setPodspecValidationEnabled(true)
        }

        print("Will disable validation code in Cocoapods")
        try cocoapodsValidationPatcher.setPodspecValidationEnabled(false)
        
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
