import CiFoundation

public final class DestinationUtils {
    public static func destination() throws -> Destination {
        let destinations: [Destination] = try readJson(
            fileName: destinationFile()
        )
        
        if let first = destinations.first {
            return first
        } else {
            throw ErrorString("Destination file doesn't contain any destination")
        }
    }
    
    public static func destinationFile() throws -> String {
        let destination = try Env.MIXBOX_CI_DESTINATION.getOrThrow()
        
        return "\(try repoRoot())/ci/destinations/\(destination)"
    }
    
    public static func xcodeDestination() throws -> String {
        guard let udid = try SimulatorUtils.destinationDeviceUdid() else {
            throw ErrorString("destinationDeviceUdid returned nil")
        }
        return "id=\(udid)"
    }
}
