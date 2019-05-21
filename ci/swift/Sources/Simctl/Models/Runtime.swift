public final class Runtime: Codable {
    public let bundlePath: String // Example: "/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 9.3.simruntime"
    public let availabilityError: String // Example: ""
    public let buildversion: String // Example: "13E233"
    public let availability: String // Example: "(available)"
    public let isAvailable: Bool // Example: true
    public let identifier: String // Example: "com.apple.CoreSimulator.SimRuntime.iOS-9-3"
    public let version: String // Example: "9.3"
    public let name: String // Example: "iOS 9.3"
    
    public init(
        bundlePath: String,
        availabilityError: String,
        buildversion: String,
        availability: String,
        isAvailable: Bool,
        identifier: String,
        version: String,
        name: String)
    {
        self.bundlePath = bundlePath
        self.availabilityError = availabilityError
        self.buildversion = buildversion
        self.availability = availability
        self.isAvailable = isAvailable
        self.identifier = identifier
        self.version = version
        self.name = name
    }
}
