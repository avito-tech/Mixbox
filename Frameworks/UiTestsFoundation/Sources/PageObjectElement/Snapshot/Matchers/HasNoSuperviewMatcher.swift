import MixboxTestsFoundation

public final class HasNoSuperviewMatcher: Matcher<ElementSnapshot> {
    public init() {
        super.init(
            description: {
                "doesn't have superview"
            },
            matchingFunction: { snapshot in
                if snapshot.parent == nil {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            "element has superview"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
