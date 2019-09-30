public final class XcodeVersion: Comparable {
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public static let xcode_10_0 = XcodeVersion(major: 10, minor: 0)
    public static let xcode_10_1 = XcodeVersion(major: 10, minor: 1)
    public static let xcode_10_2 = XcodeVersion(major: 10, minor: 2)
    public static let xcode_10_2_1 = XcodeVersion(major: 10, minor: 2, patch: 1)
    public static let xcode_10_3 = XcodeVersion(major: 10, minor: 3)
    public static let xcode_11_0 = XcodeVersion(major: 11, minor: 0)
    
    public init(
        major: Int,
        minor: Int,
        patch: Int = 0)
    {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public static func ==(lhs: XcodeVersion, rhs: XcodeVersion) -> Bool {
        return lhs.major == rhs.major
            && lhs.minor == rhs.minor
            && lhs.patch == rhs.patch
    }
    
    public static func <(lhs: XcodeVersion, rhs: XcodeVersion) -> Bool {
        if lhs.major < rhs.major {
            return true
        } else if lhs.major == rhs.major {
            if lhs.minor < rhs.minor {
                return true
            } else if lhs.minor == rhs.minor {
                return lhs.patch < rhs.patch
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
