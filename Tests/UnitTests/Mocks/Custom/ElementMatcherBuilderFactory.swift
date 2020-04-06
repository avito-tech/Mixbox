import MixboxUiTestsFoundation

final class ElementMatcherBuilderFactory {
    static func elementMatcherBuilder() -> ElementMatcherBuilder {
        return ElementMatcherBuilder(
            screenshotTaker: ScreenshotTakerStub(),
            snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGeneratorStub(),
            snapshotsComparatorFactory: SnapshotsComparatorFactoryStub()
        )
    }
}
