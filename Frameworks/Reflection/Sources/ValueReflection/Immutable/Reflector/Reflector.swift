// Name may be misleading.
//
// This is an utiliity that is shared between classes that is responsible
// for making certain model object for reflected values.
//
// Those classes will parse Mirror or raw value and generate models for
// specific kinds of reflections, e.g., for enums, structs, etc, instead of
// just ambigous Mirror that needs this kind of parsing.
//
// Q: Why both `value` and `mirror` are needed?
// A: Class and superclass mirrors share same value. As a bonus it's faster to
//    reuse existing mirror if it's already calculated (to not create another same mirror).
//
public protocol Reflector {
    var value: Any { get }
    var mirror: Mirror { get }
    
    func nestedValueReflection(value: Any, mirror: Mirror) -> TypedImmutableValueReflection
}

extension Reflector {
    public func nestedValueReflection(
        value: Any)
        -> TypedImmutableValueReflection
    {
        return nestedValueReflection(
            value: value,
            mirror: Mirror(reflecting: value)
        )
    }
}
