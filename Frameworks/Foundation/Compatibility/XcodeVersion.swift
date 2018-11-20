public enum XcodeVersion {
    case v10orHigher
    case v9orLower
    
    public static let iPhoneOsVersionMaxAllowed: Int64 = COMPACTIBILITY_IPHONE_OS_VERSION_MAX_ALLOWED
    
    // I am not sure about correspondance of iPhoneOsVersionMaxAllowed and xcodeVersion
    // It just works for my current Xcode 9 and Xcode 10. I can not find proper table on the Internet.
    public static var xcodeVersion: XcodeVersion {
        if iPhoneOsVersionMaxAllowed >= 120000 {
            return .v10orHigher
        } else {
            return .v9orLower
        }
    }
}
