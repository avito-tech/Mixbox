// Codable Void, for using in generics. Swift's builtin Void  is not Codable.
//
// Example:
// typealias Arguments = IpcVoid
public final class IpcVoid: Codable, Equatable {
    public init() {
    }
    
    public static func ==(_: IpcVoid, _: IpcVoid) -> Bool {
        return true
    }
}
