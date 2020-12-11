// Note: Copypasted from `Optional+Map.swift` from `MixboxFoundation`,
// which is incompatible wiith SPM due to mixed Obj-C and Swift code.
extension Optional {
    func map<T>(
        default: @autoclosure () -> T,
        transform: (Wrapped) throws -> T)
        rethrows
        -> T
    {
        return try map(transform) ?? `default`()
    }
    
    func flatMap<T>(
        default: @autoclosure () -> T,
        transform: (Wrapped) throws -> T?)
        rethrows
        -> T
    {
        return try flatMap(transform) ?? `default`()
    }
}
