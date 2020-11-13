import MixboxFoundation

// Model describing what is expected to be called.
// There can be many expectations per function.
// Reference to a function is in another place.
public final class Expectation {
    public let matcher: FunctionalMatcher<Any>
    public let times: FunctionalMatcher<Int>
    public let fileLine: FileLine
    
    public init(
        matcher: FunctionalMatcher<Any>,
        times: FunctionalMatcher<Int>,
        fileLine: FileLine)
    {
        self.matcher = matcher
        self.times = times
        self.fileLine = fileLine
    }
}
