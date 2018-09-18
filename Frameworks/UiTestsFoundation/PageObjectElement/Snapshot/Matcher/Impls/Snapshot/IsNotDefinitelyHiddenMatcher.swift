public final class IsNotDefinitelyHiddenMatcher: Matcher<ElementSnapshot> {
    public init() {
        super.init(
            description: {
                "не является явно скрытым"
            },
            matchingFunction: { snapshot in
                if let isDefinitelyHidden = snapshot.isDefinitelyHidden.value {
                    if isDefinitelyHidden {
                        return .exactMismatch(
                            mismatchDescription: { "вьюшка или один из ее родителей скрыты" }
                        )
                    } else {
                        return .match
                    }
                }
                
                return .match
            }
        )
    }
}
