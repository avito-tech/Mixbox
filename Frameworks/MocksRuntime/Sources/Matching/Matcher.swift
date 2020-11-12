public protocol Matcher {
    associatedtype MatchingType
    func valueIsMatching(_ value: MatchingType) -> Bool
}

extension Equatable {
    public func valueIsMatching(_ value: Self) -> Bool {
        return self == value
    }
}

extension AnyIndex: Matcher {}
extension AutoreleasingUnsafeMutablePointer: Matcher {}
extension Bool: Matcher {}
extension OpaquePointer: Matcher {}
extension Character: Matcher {}
extension ClosedRange: Matcher {}
extension DictionaryIndex: Matcher {}
extension Double: Matcher {}
extension Float: Matcher {}
extension Float80: Matcher {}
extension Range: Matcher {}
extension Int: Matcher {}
extension Int16: Matcher {}
extension Int32: Matcher {}
extension Int64: Matcher {}
extension Int8: Matcher {}
extension ManagedBufferPointer: Matcher {}
extension ObjectIdentifier: Matcher {}
extension Set: Matcher {}
extension SetIndex: Matcher {}
extension String: Matcher {}
extension UInt: Matcher {}
extension UInt16: Matcher {}
extension UInt32: Matcher {}
extension UInt64: Matcher {}
extension UInt8: Matcher {}
extension UnicodeScalar: Matcher {}
extension UnsafeMutablePointer: Matcher {}
extension UnsafePointer: Matcher {}
