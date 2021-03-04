import Bash
import Foundation
import CiFoundation
import Tasks
import SingletonHell
import Emcee
import Destinations
import Xcodebuild
import Bundler

public final class ReleaseToCocoapodsTask: LocalTask {
    public let name = "ReleaseToCocoapodsTask"
    
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func execute() throws {
        let version = getNextReleaseVersion()
        
        setUpTagsBeforeRelease(version: version)
        
        patchPodspecs(version: version)
        validatePodspecs()
        pushPodspecs()
        
        setUpTagsAfterRelease(version: version)
    }
    
    private func getNextReleaseVersion() -> String {
        // TBD
        return ""
    }
    
    private func setUpTagsBeforeRelease(version: String) {
        // TBD.
        // Should set a normal tag with version
        // And also a marker tag that this is WIP release.
        // If release process fails, the marker will help to
        // revert that version tag (nothing was actually released)
        // thus there will be no tags for missing releases.
        // Only if everything succeeds, marker will be removed.
    }
    
    private func patchPodspecs(version: String) {
        // TBD.
        // Will set version of every podspec
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
    
    private func setUpTagsAfterRelease(version: String) {
        // TBD.
        // Will finalize tags (e.g. remove marker tag that
        // says that release is unfinished)
    }
}
