import CiFoundation
import Bash
import Foundation
import RemoteFiles

public final class EmceeInstallerImpl: EmceeInstaller {
    private let emceeExecutablePath: String
    
    public init(
        emceeExecutablePath: String
    ) {
        self.emceeExecutablePath = emceeExecutablePath
    }
    
    public func installEmcee() throws -> String {
        return emceeExecutablePath
    }
}
