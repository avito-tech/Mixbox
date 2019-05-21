public final class Device: Codable {
    public let availability: String // Example: "(available)"
    public let state: String // Example: "Shutdown"
    public let isAvailable: Bool // Example: true
    public let name: String // Example: "iPhone 5s"
    public let udid: String // Example: "88699C06-9D14-4100-BF80-194AB8359991"
    public let availabilityError: String // Example: ""
    
    public init(
        availability: String,
        state: String,
        isAvailable: Bool,
        name: String,
        udid: String,
        availabilityError: String)
    {
        self.availability = availability
        self.state = state
        self.isAvailable = isAvailable
        self.name = name
        self.udid = udid
        self.availabilityError = availabilityError
    }
}
