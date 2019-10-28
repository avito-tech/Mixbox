public final class IsNotDefinitelyHiddenMatcher: Matcher<ElementSnapshot> {
    public init() {
        super.init(
            description: {
                "не является явно скрытым"
            },
            matchingFunction: { snapshot in
                if let isDefinitelyHidden = snapshot.isDefinitelyHidden.valueIfAvailable {
                    if isDefinitelyHidden {
                        return .exactMismatch(
                            mismatchDescription: { "вьюшка или один из ее родителей скрыты" },
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
