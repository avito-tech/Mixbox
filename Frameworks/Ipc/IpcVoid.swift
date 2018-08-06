// Codable Void, for using in generics. Swift's builtin Void  is not Codable.
//
// Example:
// typealias Arguments = IpcVoid
public final class IpcVoid: Codable {
    public init() {
    }
}
