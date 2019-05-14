import MixboxFoundation

public final class ReferenceImageMatcher: Matcher<ElementSnapshot> {
    public init(
        screenshotTaker: ScreenshotTaker,
        referenceImage: UIImage,
        comparator: SnapshotsComparator)
    {
        super.init(
            description: {
                "Совпадает с референсным скрином"
            },
            matchingFunction: { snapshot -> MatchingResult in
                guard let actual = screenshotTaker.elementImage(elementShanpshot: snapshot) else {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: {
                            "Не удалось создать скрин элемента"
                        }
                    )
                }
                // TODO: Display the actual and diff screenshots in the report in case of a mismatch
                return comparator.equals(actual: actual, expected: referenceImage)
            }
        )
    }
}
