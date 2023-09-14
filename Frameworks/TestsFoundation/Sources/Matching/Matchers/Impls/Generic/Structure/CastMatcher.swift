public class CastMatcher<Source, Target>: Matcher<Source> {
    public init(
        _ matcher: Matcher<Target>,
        castingOperator: @escaping (Source) -> (Target?) = { $0 as? Target })
    {
        super.init(
            description: {
                "is inherited from \(Target.self) and \(matcher.wrappedDescription)"
            },
            matchingFunction: { value in
                if let castedValue = castingOperator(value) {
                    return matcher.match(value: castedValue)
                } else {
                    return .exactMismatch(
                        mismatchDescription: { "is not inherited from \(Target.self)" },
                        attachments: { [] }
                    ) 
                }
            }
        )
    }
}
