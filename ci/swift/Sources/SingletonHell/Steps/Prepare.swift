import Foundation
import CiFoundation

// Translated from `prepare.sh`.
// TODO: Rewrite.
public final class Prepare {
    public static func prepareForMacOsTesting() throws {
        try prepareForTesting()
    }
    
    public static func prepareForIosTesting(rebootSimulator: Bool) throws {
        try prepareForTesting()
        
        if rebootSimulator {
            // Improves stability of launching tests
            try SimulatorUtils.shutdownDevices()
        }
        
        try SimulatorUtils.setUpSimulatorIfNeeded()
        
        if rebootSimulator {
            // This is done in background and prepares simulator
            try SimulatorUtils.bootDevice()
        }
    }
    
    private static func prepareForTesting() throws {
        let cocoapodsVersion = "1.7.0"
        
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
