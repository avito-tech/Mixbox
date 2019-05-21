public final class DeviceInPair: Codable {
    public let name: String // Example: "iPhone 5s"
    public let udid: String // Example: "88699C06-9D14-4100-BF80-194AB8359991"
    public let state: String // Example: "Shutdown"
    
    public init(
        name: String,
        udid: String,
        state: String)
    {
        self.name = name
        self.udid = udid
        self.state = state
    }
}

public final class Pair: Codable {
    public let watch: DeviceInPair
    public let phone: DeviceInPair
    public let state: String
    
    public init(
        watch: DeviceInPair,
        phone: DeviceInPair,
        state: String)
    {
        self.watch = watch
        self.phone = phone
        self.state = state
    }
}
