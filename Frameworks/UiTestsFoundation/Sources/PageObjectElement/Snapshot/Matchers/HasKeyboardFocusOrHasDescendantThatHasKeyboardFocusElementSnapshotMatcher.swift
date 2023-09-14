import MixboxTestsFoundation

public final class HasKeyboardFocusOrHasDescendantThatHasKeyboardFocusElementSnapshotMatcher: Matcher<ElementSnapshot> {
    public init() {
        super.init(
            description: {
                "has keyboard focus or one of the nested elements has keyboard focus"
            },
            matchingFunction: { snapshot in
                if snapshot.hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus() {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            "hasn't keyboard focus and none of the nested elements has keyboard focus"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}

private extension ElementSnapshot {
    func hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus() -> Bool {
        if hasKeyboardFocus {
            return true
        }
        
        for child in children {
            if child.hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus() {
                return true
            }
        }
        
        return false
    }
}
