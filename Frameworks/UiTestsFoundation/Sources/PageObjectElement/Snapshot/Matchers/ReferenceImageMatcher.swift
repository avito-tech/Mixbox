import MixboxFoundation
import MixboxTestsFoundation

public final class ReferenceImageMatcher: Matcher<ElementSnapshot> {
    public init(
        elementImageProvider: ElementImageProvider,
        referenceImage: UIImage,
        snapshotsComparator: SnapshotsComparator,
        snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator)
    {
        super.init(
            description: {
                "Совпадает с референсным скрином"
            },
            matchingFunction: { snapshot -> MatchingResult in
                let actualImage: UIImage
                
                do {
                    actualImage = try elementImageProvider.elementImage(elementShanpshot: snapshot)
                } catch {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: {
                            "Failed to get screenshot of the element: \(error)"
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
