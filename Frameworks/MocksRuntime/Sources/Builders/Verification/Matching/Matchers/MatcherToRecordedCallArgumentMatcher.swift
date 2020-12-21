import MixboxTestsFoundation

public final class MatcherToRecordedCallArgumentMatcher: Matcher<RecordedCallArgument> {
    public init<T>(matcher: Matcher<T>) {
        super.init(
            description: {
                "recorded call argument matches '\(matcher.description)'"
            },
            matchingFunction: { argument in
                if let value = argument.value.typedNestedValue(type: T.self) {
                    return matcher.match(value: value)
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            argument value is not \(T.self), \
                            actual argument: \(argument)
                            """
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
