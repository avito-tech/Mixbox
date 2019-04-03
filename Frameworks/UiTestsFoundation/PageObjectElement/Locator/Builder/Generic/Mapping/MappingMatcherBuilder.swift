// Allows making builders for matchers with ability to wrap matchers.
//
// Example (with MappingMatcherBuilderImpl):
//
// // Creates matcher builder that creates matchers for CGRect,
// // but is able to wrap every matcher in given matcher (HasPropertyMatcher):
// let x = MappingMatcherBuilderImpl {
//     HasPropertyMatcher(
//         property: getter,
//         name: name,
//         matcher: $0
//     )
// }
//
// // Creates HasPropertyMatcher<CGRect, CGFloat>(property: { $0.x }, name: "x", matcher: EqualsMatcher(1))
// // Which can be upcasted to Matcher<CGRect>. Note that we wrap Matcher<CGFloat>.
// x.matcher(EqualsMatcher(1))
//
// // Example in which protocol extensions are used (creates same matcher):
// x == 1
//
public protocol MappingMatcherBuilder {
    associatedtype TargetMatcherArgument
    associatedtype SourceMatcherArgument
    
    func matcher(_ matcher: Matcher<SourceMatcherArgument>) -> Matcher<TargetMatcherArgument>
}

extension MappingMatcherBuilder where SourceMatcherArgument: IsCloseMatcherCompatible {
    public func isClose(to: SourceMatcherArgument, delta: SourceMatcherArgument) -> Matcher<TargetMatcherArgument> {
        return matcher(IsCloseMatcher(expectedValue: to, delta: delta))
    }
}
