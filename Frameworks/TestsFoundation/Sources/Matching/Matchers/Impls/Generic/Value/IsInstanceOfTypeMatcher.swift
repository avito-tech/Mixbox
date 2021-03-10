public final class IsInstanceOfTypeMatcher<ActualType, ExpectedType>:
    Matcher<ActualType>
{
    public init() {
        super.init(
            description: {
                "is instance of type \(ExpectedType.self)"
            },
            matchingFunction: { actualValue in
                if actualValue is ExpectedType {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            value is not instance of type '\(ExpectedType.self)', \
                            actual type: '\(Swift.type(of: actualValue))')
                            """
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
