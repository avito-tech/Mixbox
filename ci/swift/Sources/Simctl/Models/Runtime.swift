public final class Runtime: Codable {
    // Always nil in Xcode 10 (or lower)
    // Always non-nil in Xcode 10.1 and 10.2.1 (maybe other)
     // Example: "/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 9.3.simruntime"
    public let bundlePath: String?
    
    // Always nil in Xcode 10 (or lower)
    // Always non-nil in Xcode 10.1 and 10.2.1 (maybe other)
    // Example: ""
    public let availabilityError: String?
    
     // Example: "13E233"
    public let buildversion: String
    
    // Always nil in Xcode 11 (or higher, maybe)
    // Always non-nil in Xcode 10
    // Example: "(available)"
    public let availability: String?
    
    // Always nil in Xcode 10 (or lower)
    // Always non-nil in Xcode 10.1 and 10.2.1 (maybe other)
    public let isAvailable: Bool?
    
    // Example: "com.apple.CoreSimulator.SimRuntime.iOS-9-3"
    public let identifier: String
    
    // Example: "9.3"
    public let version: String
    
    // Example: "iOS 9.3"
    public let name: String
    
    public init(
        bundlePath: String?,
        availabilityError: String?,
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
