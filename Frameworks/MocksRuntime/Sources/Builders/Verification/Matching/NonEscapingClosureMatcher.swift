// Use only to support overloads of functions in mocks (to differentiate between signatures)
// It can't be a real matcher, because non-escaping closure can't be captured.
//
// ClosureType: example: `(inout Int) throws -> ()`
public final class NonEscapingClosureMatcher<ClosureType> {}

public func any<T>() -> NonEscapingClosureMatcher<T> {
    return NonEscapingClosureMatcher()
}
