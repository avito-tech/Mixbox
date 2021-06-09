// Note: if we need a more powerful solution, there is https://github.com/mxcl/Version
public final class Version {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public init(
        major: Int,
        minor: Int,
        patch: Int)
    {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public func toString() -> String {
        return "\(major).\(minor).\(patch)"
    }
    
    public convenience init?(versionString: String) {
        let components = versionString.components(separatedBy: ".")
        
        guard components.count == 3 else {
            return nil
        }
        
        guard
            let majorUnsigned = UInt(components[0]),
            let minorUnsigned = UInt(components[1]),
            let patchUnsigned = UInt(components[2])
        else {
            return nil
        }
        
        guard
            let majorSigned = Int(exactly: majorUnsigned),
            let minorSigned = Int(exactly: minorUnsigned),
            let patchSigned = Int(exactly: patchUnsigned)
        else {
            return nil
        }
        
        self.init(
            major: majorSigned,
            minor: minorSigned,
            patch: patchSigned
        )
    }
}
