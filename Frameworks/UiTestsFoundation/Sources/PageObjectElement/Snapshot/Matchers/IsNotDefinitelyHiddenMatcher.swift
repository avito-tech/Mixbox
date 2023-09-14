import MixboxTestsFoundation

public final class IsNotDefinitelyHiddenMatcher: Matcher<ElementSnapshot> {
    public init() {
        super.init(
            description: {
                "element is not definitely hidden"
            },
            matchingFunction: { snapshot in
                if let isDefinitelyHidden = snapshot.isDefinitelyHidden.valueIfAvailable {
                    if isDefinitelyHidden {
                        return .exactMismatch(
                            mismatchDescription: { "element or one of its parents are hidden" },
                            attachments: { [] }
                        )
                    } else {
                        return .match
                    }
                } else {
                    // TODO: Fallback for third party apps?
                }
                
                return .match
            }
        )
    }
}
