import MixboxTestsFoundation

public final class NonEscapingClosureTypeToRecordedCallArgumentMatcher: Matcher<RecordedCallArgument> {
    public init(closureType: Any.Type) {
        super.init(
            description: {
                "is nonescaping closure of type '\(closureType)'"
            },
            matchingFunction: { argument in
                guard argument.value.isNonEscapingClosure() else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            argument is not non-escaping closure, argument: '\(argument)'
                            """
                        },
                        attachments: { [] }
                    )
                }
                
                guard argument.type == closureType else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            argument is non-escaping closure, \
                            but is not of type \(closureType), \
                            actual type: '\(argument.type)'
                            """
                        },
                        attachments: { [] }
                    )
                }
                
                return .match
            }
        )
    }
}
