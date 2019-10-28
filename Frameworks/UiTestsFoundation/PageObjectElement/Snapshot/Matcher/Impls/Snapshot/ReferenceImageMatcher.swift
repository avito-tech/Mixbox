import MixboxFoundation

public final class ReferenceImageMatcher: Matcher<ElementSnapshot> {
    public init(
        screenshotTaker: ScreenshotTaker,
        referenceImage: UIImage,
        snapshotsComparator: SnapshotsComparator,
        snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator)
    {
        super.init(
            description: {
                "Совпадает с референсным скрином"
            },
            matchingFunction: { snapshot -> MatchingResult in
                guard let actualImage = screenshotTaker.elementImage(elementShanpshot: snapshot) else {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: {
                            "Не удалось создать скрин элемента"
                        },
                        attachments: { [] }
                    )
                }
                
                let comparisonResult = snapshotsComparator.compare(
                    actualImage: actualImage,
                    expectedImage: referenceImage
                )
                
                switch comparisonResult {
                case .similar:
                    return .match
                case .different(let description):
                    return .partialMismatch(
                        percentageOfMatching: description.percentageOfMatching,
                        mismatchDescription: { description.message },
                        attachments: { [snapshotsDifferenceAttachmentGenerator] in
                            snapshotsDifferenceAttachmentGenerator.attachments(
                                snapshotsDifferenceDescription: description
                            )
                        }
                    )
                }
            }
        )
    }
}
