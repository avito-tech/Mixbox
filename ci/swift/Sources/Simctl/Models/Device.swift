public final class Device: Codable {
    // Always nil in Xcode 11 (or higher, maybe)
    // Always non-nil in Xcode 10
    // Example: "(available)"
    public let availability: String?
    
    // Example: "Shutdown"
    public let state: String
    
    // Always nil in Xcode 10 (or lower)
    // Always non-nil in Xcode 10.1 and 10.2.1 (maybe other)
    public let isAvailable: Bool?
    
    // Example: "iPhone 5s"
    public let name: String
    
    // Example: "88699C06-9D14-4100-BF80-194AB8359991"
    public let udid: String
    
    // Always nil in Xcode 10 (or lower)
    // Always non-nil in Xcode 10.1 and 10.2.1 (maybe other)
    // Example: ""
    public let availabilityError: String?
    
    public init(
        availability: String,
        state: String,
        isAvailable: Bool?,
        name: String,
        udid: String,
        availabilityError: String?)
    {
        self.availability = availability
        self.state = state
        self.isAvailable = isAvailable
        self.name = name
        self.udid = udid
        self.availabilityError = availabilityError
    }
}
