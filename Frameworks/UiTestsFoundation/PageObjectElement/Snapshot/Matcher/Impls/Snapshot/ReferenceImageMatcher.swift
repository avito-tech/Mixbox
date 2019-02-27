import MixboxFoundation

public final class ReferenceImageMatcher: Matcher<ElementSnapshot> {
    public init(
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        reference: UIImage,
        comparator: SnapshotsComparator)
    {
        super.init(
            description: {
                "Совпадает с референсным скрином"
            },
            matchingFunction: { snapshot -> MatchingResult in
                guard let actual = snapshot.image else {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: {
                            "Не удалось создать скрин элемента"
                        }
                    )
                }
                switch snapshotsComparisonUtility.compare(
                    actual: actual,
                    reference: reference,
                    comparator: comparator
                ) {
                case .passed:
                    return .match
                case let .failed(failure):
                    return MatchingResult.exactMismatch(
                        mismatchDescription: { failure.message }
                    )
                }
            }
        )
    }
}

