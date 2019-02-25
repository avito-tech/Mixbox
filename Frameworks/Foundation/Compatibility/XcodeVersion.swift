public enum XcodeVersion {
    case v10orHigher
    case v9orLower
    
    public static var xcodeVersion: XcodeVersion {
        #if swift(>=4.1.50)
            return .v10orHigher
        #else
            return .v9orLower
        #endif
    }
}
