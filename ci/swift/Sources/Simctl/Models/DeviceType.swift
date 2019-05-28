public final class DeviceType: Codable {
    // Example: "Apple TV"
    public let name: String
    
    // Always nil in Xcode 10 (or lower)
    // Always non-nil in Xcode 10.1 and 10.2.1 (maybe other)
    // Example:  "/Applications/Xcode.app/Contents/Developer/Platforms/AppleTVOS.platform/Developer/Library/CoreSimulator/Profiles/DeviceTypes/Apple TV.simdevicetype"
    public let bundlePath: String?
    
    // Example: "com.apple.CoreSimulator.SimDeviceType.Apple-TV-1080p"
    public let identifier: DeviceTypeIdentifier
    
    public init(
        name: String,
        bundlePath: String?,
        identifier: String)
    {
        self.name = name
        self.bundlePath = bundlePath
        self.identifier = identifier
    }
}
