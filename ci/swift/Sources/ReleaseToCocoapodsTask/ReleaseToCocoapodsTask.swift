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
        patchPodspecs()
        validatePodspecs()
        pushPodspecs()
    }
    
    private func patchPodspecs() {
        // TBD. Will increment version of podspec based on last released version
    }
    private func validatePodspecs() {
        // TBD
    }
    private func pushPodspecs() {
        // TBD
    }
}
