public final class HasKeyboardFocusOrHasDescendantThatHasKeyboardFocusElementSnapshotMatcher: Matcher<ElementSnapshot> {
    public init() {
        super.init(
            description: {
                "имеет фокус клавиатуры или один из вложенных элементов имеет фокус клавиатуры"
            },
            matchingFunction: { snapshot in
                if snapshot.hasKeyboardFocusOrHasDescendantThatHasKeyboardFocus() {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            "не имеет фокус клавиатуры и ни один из вложенных элементов не имеет фокус клавиатуры"
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
