import MixboxFoundation

public final class XcodeVersionProvider {
    public static func xcodeVersion() throws -> XcodeVersion {
        let components = XcodeVersionProviderObjC.xcodeVersion()
        
        guard components.count == 3 else {
            throw ErrorString("Can not get version of Xcode, got version components: \(components)")
        }
        
        return XcodeVersion(
            major: components[0].intValue,
            minor: components[1].intValue,
            patch: components[2].intValue
        )
    }
    
    public static func xcodeVersionOrFail() -> XcodeVersion {
        do {
            return try xcodeVersion()
        } catch {
            UnavoidableFailure.fail("\(error)")
        }
    }
}
