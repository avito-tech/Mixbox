// Use carefully. Don't store non-escaping closures
// outside of objects that are allocated on stack and will be
// deallocated when call to a mock object will finish.
// All nonescaping closures are used inside `withoutActuallyEscaping` block
// and this block checks that reference count of closures equals 1 and crashes otherwise.
public final class NonEscapingClosureArgumentValue {
    public let value: Any
    public let reflection: ClosureArgumentValueReflection
    
    public init(
        value: Any,
        reflection: ClosureArgumentValueReflection)
    {
        self.value = value
        self.reflection = reflection
    }
}
