import MixboxUiTestsFoundation

final class ElementMatcherBuilderFactory {
    static func elementMatcherBuilder() -> ElementMatcherBuilder {
        return ElementMatcherBuilder(
            elementImageProvider: MockElementImageProvider(),
            snapshotsDifferenceAttachmentGenerator: MockSnapshotsDifferenceAttachmentGenerator(),
            snapshotsComparatorFactory: MockSnapshotsComparatorFactory()
        )
    }
}
