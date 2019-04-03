import MixboxFoundation

public final class ReferenceImageMatcher: Matcher<ElementSnapshot> {
    public init(
        screenshotTaker: ScreenshotTaker,
        reference: UIImage,
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
                if comparator.equals(actual: actual, reference: reference) {
                    return .match
                } else {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: {
                            "Актуальное и референсное изображения не совпадают"
                        }
                    )
                }
            }
        )
    }
}

