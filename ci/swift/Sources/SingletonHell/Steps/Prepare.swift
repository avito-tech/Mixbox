import Foundation
import CiFoundation

// Translated from `prepare.sh`.
// TODO: Rewrite.
public final class Prepare {
    public static func prepareForMacOsTesting() throws {
        try prepareForTesting()
    }
    
    public static func prepareForIosTesting() throws {
        try prepareForTesting()
        
        // Improves stability of launching tests
        try SimulatorUtils.shutdownDevices()
        try SimulatorUtils.setUpSimulatorIfNeeded()
        
        // This is done in background and prepares simulator
        try SimulatorUtils.bootDevice()
    }
    
    private static func prepareForTesting() throws {
        // TODO: Bump to 1.6.1
        let cocoapodsVersion = "1.5.3"
        
        // Requires "sudo without password" if ruby requires sudo
        try bash(
            """
            (which pod && [ `pod --version` == "\(cocoapodsVersion)" ]) \
            || gem install cocoapods -v "\(cocoapodsVersion)" \
            || sudo gem install cocoapods -v "\(cocoapodsVersion)"
            which xcpretty || brew install xcpretty
            which jq || brew install jq
            """
        )
        
        try mkdirp(Env.MIXBOX_CI_REPORTS_PATH.getOrThrow())
        _ = try? rmrf(Variables.temporaryDirectory())
        try mkdirp(Variables.temporaryDirectory())
    }
}
