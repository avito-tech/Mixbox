import MixboxUiTestsFoundation

final class ElementMatcherBuilderFactory {
    static func elementMatcherBuilder() -> ElementMatcherBuilder {
        return ElementMatcherBuilder(
            screenshotTaker: MockScreenshotTaker(),
            snapshotsDifferenceAttachmentGenerator: MockSnapshotsDifferenceAttachmentGenerator(),
            snapshotsComparatorFactory: MockSnapshotsComparatorFactory()
        )
    }
}
