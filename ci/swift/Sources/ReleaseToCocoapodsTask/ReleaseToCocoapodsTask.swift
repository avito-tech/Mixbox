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
    private let headCommitHashProvider: HeadCommitHashProvider
    private let nextReleaseVersionProvider: NextReleaseVersionProvider
    private let beforeReleaseTagsSetter: BeforeReleaseTagsSetter
    private let mixboxPodspecsValidator: MixboxPodspecsValidator
    private let mixboxPodspecsPusher: MixboxPodspecsPusher
    private let mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider
    private let environmentProvider: EnvironmentProvider
    private let afterReleaseTagsSetterForExistingReleaseProvider: AfterReleaseTagsSetterForExistingReleaseProvider
    private let currentReleaseVersionProvider: CurrentReleaseVersionProvider
    
    private enum Mode {
        case createNewRelease
        case continueRelease(skipValidation: Bool)
    }
    
    public init(
        headCommitHashProvider: HeadCommitHashProvider,
        nextReleaseVersionProvider: NextReleaseVersionProvider,
        beforeReleaseTagsSetter: BeforeReleaseTagsSetter,
        mixboxPodspecsValidator: MixboxPodspecsValidator,
        mixboxPodspecsPusher: MixboxPodspecsPusher,
        mixboxReleaseSettingsProvider: MixboxReleaseSettingsProvider,
        environmentProvider: EnvironmentProvider,
        afterReleaseTagsSetterForExistingReleaseProvider: AfterReleaseTagsSetterForExistingReleaseProvider,
        currentReleaseVersionProvider: CurrentReleaseVersionProvider)
    {
        self.headCommitHashProvider = headCommitHashProvider
        self.nextReleaseVersionProvider = nextReleaseVersionProvider
        self.beforeReleaseTagsSetter = beforeReleaseTagsSetter
        self.mixboxPodspecsValidator = mixboxPodspecsValidator
        self.mixboxPodspecsPusher = mixboxPodspecsPusher
        self.mixboxReleaseSettingsProvider = mixboxReleaseSettingsProvider
        self.environmentProvider = environmentProvider
        self.afterReleaseTagsSetterForExistingReleaseProvider = afterReleaseTagsSetterForExistingReleaseProvider
        self.currentReleaseVersionProvider = currentReleaseVersionProvider
    }
    
    public func execute() throws {
        let commitHashToRelease = try headCommitHashProvider.headCommitHash()
        
        let afterReleaseTagsSetter = try prepareForRelease(
            commitHashToRelease: commitHashToRelease
        )
        
        try mixboxPodspecsPusher.pushMixboxPodspecs()
        
        try afterReleaseTagsSetter.setUpTagsAfterRelease()
    }
    
    private func prepareForRelease(
        commitHashToRelease: String)
        throws
        -> AfterReleaseTagsSetter
    {
        let afterReleaseTagsSetter: AfterReleaseTagsSetter
        let shouldValdate: Bool
        
        switch try mode() {
        case .createNewRelease:
            afterReleaseTagsSetter = try prepareVersionForNewRelease(commitHashToRelease: commitHashToRelease)
            shouldValdate = true
        case .continueRelease(let skipValidation):
            afterReleaseTagsSetter = try prepareVersionForContinuingRelease(commitHashToRelease: commitHashToRelease)
            shouldValdate = !skipValidation
        }
        
        if shouldValdate {
            try mixboxPodspecsValidator.validateMixboxPodspecs()
        }
        
        return afterReleaseTagsSetter
    }
    
    private func prepareVersionForNewRelease(
        commitHashToRelease: String)
        throws
        -> AfterReleaseTagsSetter
    {
        let version = try nextReleaseVersionProvider.nextReleaseVersion(
            majorVersion: mixboxReleaseSettingsProvider.majorVersion,
            minorVersion: mixboxReleaseSettingsProvider.minorVersion,
            commitHashToRelease: commitHashToRelease,
            releaseBranchName: mixboxReleaseSettingsProvider.releaseBranchFullName
        )
        
        return try beforeReleaseTagsSetter.setUpTagsBeforeRelease(
            version: version,
            commitHash: commitHashToRelease,
            remote: mixboxReleaseSettingsProvider.releaseRemoteName
        )
    }
    
    private func prepareVersionForContinuingRelease(
        commitHashToRelease: String)
        throws
        -> AfterReleaseTagsSetter
    {
        let version = try currentReleaseVersionProvider.currentReleaseVersion(
            commitHashToRelease: commitHashToRelease,
            releaseBranchName: mixboxReleaseSettingsProvider.releaseBranchFullName
        )
        
        return afterReleaseTagsSetterForExistingReleaseProvider
            .afterReleaseTagsSetterForExistingRelease(
                version: version,
                remote: mixboxReleaseSettingsProvider.releaseRemoteName
            )
    }
    
    private func mode() throws -> Mode {
        let modeEnvName = "MIXBOX_CI_RELEASE_TO_COCOAPODS_MODE"
        
        guard let modeString = environmentProvider.environment[modeEnvName] else {
            return .createNewRelease
        }
        
        let createNewReleaseCaseName = "createNewRelease"
        let continueReleaseCaseName = "continueRelease"
        let allCaseNames = [createNewReleaseCaseName, continueReleaseCaseName]
        
        switch modeString {
        case createNewReleaseCaseName:
            return .createNewRelease
        case continueReleaseCaseName:
            return .continueRelease(
                skipValidation: environmentProvider.environment["MIXBOX_CI_RELEASE_TO_COCOAPODS_SKIP_VALIDATION"] == "true"
            )
        default:
            throw ErrorString(
                """
                Unsupported mode. \
                Actual value of MIXBOX_CI_RELEASE_TO_COCOAPODS_MODE: \(modeString).
                Expected any value in \(allCaseNames.debugDescription)
                """
            )
        }
    }
}
