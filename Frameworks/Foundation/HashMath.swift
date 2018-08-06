// UPDATE: It was implemented in Swift 4.2:
// https://github.com/apple/swift-evolution/blob/master/proposals/0206-hashable-enhancements.md
//
// TODO: Rewrite using Swift's builtin tools.
//
// https://en.wikipedia.org/wiki/Hash_function#Perfect_hashing
//
// Use like this:
//
// var hashValue: Int {
//     return HashMath
//         .combine("Hello")
//         .combine("World")
//         .combine(42)
//         .reduce
// }
//
// If you have only one value, simply return its hash:
//
// var hashValue: Int {
//     return myUniqueIntId.hashValue
// }
//
// You can notice that hashValue of Int equals to it: 42.hashValue == 42.
// But you should not use that coincidence in your code.
//
// It is how Swift's hash map works (it's actually how all hash maps work,
// but you still shouldn't duplicate this behavior)
//
// Don't write this (even if it will work great and always be great):
//
// var hashValue: Int {
//     return myUniqueIntId
// }
//
public final class HashMath {
    @inline(__always) public static func combineHash(_ hash: Int) -> HashCombine {
        return HashCombine(reduce: hash)
    }
    
    @inline(__always) public static func combine<T: Hashable>(_ hashable: T) -> HashCombine {
        return combineHash(hashable.hashValue)
    }
    
    @inline(__always) public static func combine<T: Hashable>(_ optional: T?) -> HashCombine {
        return combineHash(HashMath.hashValue(fromOptional: optional))
    }
    
    @inline(__always) public static func combine(_ left: Int, _ right: Int) -> Int {
        // Swift equivalent of boost::hash_combine
        return left ^ (
            addWithOverflow(
                addWithOverflow(
                    addWithOverflow(
                        right,
                        Int(bitPattern: 0x9e3779b9)
                    ),
                    left << 6
                ),
                left >> 2
            )
        )
    }
    
    // Why this code exist: this can't be compiled
    // extension Optional: Hashable where Wrapped: Hashable
    //
    // Because of this error:
    // Extension of type 'Optional' with constraints cannot have an inheritance clause
    //
    // We are left to use the following (less elegant) code for getting hash value of Optional:
    public static func hashValue<T: Hashable>(fromOptional value: T?) -> Int {
        if let value = value {
            return HashMath.combine(1).combine(value).reduce
        } else {
            return 0.hashValue
        }
    }
    
    public static func addWithOverflow(_ lhs: Int, _ rhs: Int) -> Int {
        return lhs.addingReportingOverflow(rhs).partialValue
    }
}

public struct HashCombine {
    public let reduce: Int
    
    public init(reduce: Int) {
        self.reduce = reduce
    }
    
    @inline(__always) public func combineHash(_ hash: Int) -> HashCombine {
        return HashCombine(reduce: HashMath.combine(reduce, hash))
    }
    
    @inline(__always) public func combine<T: Hashable>(_ hashable: T) -> HashCombine {
        return combineHash(hashable.hashValue)
    }
    
    @inline(__always) public func combine<T: Hashable>(_ optional: T?) -> HashCombine {
        return combineHash(HashMath.hashValue(fromOptional: optional))
    }
}
