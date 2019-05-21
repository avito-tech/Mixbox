// Translated from `cleanup.sh`.
// TODO: Rewrite.
public final class Cleanup {
    public static func cleanUpAfterIosTesting() throws {
        try cleanUpAfterTesting()
        try SimulatorUtils.shutdownDevices()
    }
    
    public static func cleanUpAfterMacOsTesting() throws {
        try cleanUpAfterTesting()
    }
    
    public static func cleanUpAfterTesting() throws {
        try rmrf(Variables.temporaryDirectory())
    }
}
