public class CastMatcher<Source, Target>: Matcher<Source> {
    public init(
        _ matcher: Matcher<Target>,
        castingOperator: @escaping (Source) -> (Target?) = { $0 as? Target })
    {
        super.init(
            description: {
                "является \(Target.self) и " + matcher.description
            },
            matchingFunction: { value in
                if let castedValue = castingOperator(value) {
                    return matcher.match(value: castedValue)
                } else {
                    return .exactMismatch(
                        mismatchDescription: { "Не является \(Target.self)" },
                        attachments: { [] }
                    ) 
                }
            }
        )
    }
}
