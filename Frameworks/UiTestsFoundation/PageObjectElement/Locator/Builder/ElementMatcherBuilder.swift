// Helper for building ElementMatcher
//
// This class allows you to write locators like this:
//
//     { element in
//         element.id == "myId" && element.text = "OK"
//     }
//
//     { element in
//         element.id == "myId"
//         && element.text == "Next"
//         && element.label == "Next keyboard"
//         && element.isSubviewOf { anotherElement in
//             anotherElement.isInstanceOf(UIScrollView.self)
//             && anotherElement.id == "myScrollView"
//         }
//     }
//
// So this class does nothing except for providing syntactic sugar.
//
// TODO: add ability to compare elements? `{ element == otherElement }`
// TODO: Make protocol! It will allow Cuckoo to mock it automatically.

public typealias ElementMatcherBuilderClosure = (ElementMatcherBuilder) -> ElementMatcher

public final class ElementMatcherBuilder {
    private let screenshotTaker: ScreenshotTaker
    private let snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator
    private let snapshotsComparatorFactory: SnapshotsComparatorFactory
    
    public init(
        screenshotTaker: ScreenshotTaker,
        snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator,
        snapshotsComparatorFactory: SnapshotsComparatorFactory)
    {
        self.screenshotTaker = screenshotTaker
        self.snapshotsDifferenceAttachmentGenerator = snapshotsDifferenceAttachmentGenerator
        self.snapshotsComparatorFactory = snapshotsComparatorFactory
    }
    
    public let frameRelativeToScreen = CGRectPropertyMatcherBuilder("frameRelativeToScreen", \ElementSnapshot.frameRelativeToScreen)
    
    public let id = PropertyMatcherBuilder("id", \ElementSnapshot.accessibilityIdentifier)
    
    public let label = PropertyMatcherBuilder("label", \ElementSnapshot.accessibilityLabel)

    public let value = PropertyMatcherBuilder<ElementSnapshot, String>("value") { (snapshot: ElementSnapshot) -> String in
        // TODO: Support nils and other types
        (snapshot.accessibilityValue as? String) ?? ElementMatcherBuilder.valueToMimicComparisonOfStringToNil
    }
    
    public let placeholderValue = PropertyMatcherBuilder<ElementSnapshot, String>("placeholderValue") {
        // TODO: Support nils
        $0.accessibilityPlaceholderValue ?? ElementMatcherBuilder.valueToMimicComparisonOfStringToNil
    }
    
    public let text = PropertyMatcherBuilder<ElementSnapshot, String>("text") {
        // TODO: Support nils, remove fallbacks
        $0.text(fallback: $0.accessibilityLabel) ?? ""
    }
    
    public let isEnabled = PropertyMatcherBuilder("isEnabled", \ElementSnapshot.isEnabled)
    
    public let type = PropertyMatcherBuilder("type", \ElementSnapshot.elementType)
    
    public let customValues = CustomValuesMatcherBuilder()
    
    public func isInstanceOf(_ class: AnyClass) -> ElementMatcher {
        return IsInstanceMatcher("\(`class`)")
    }
    
    public func isInstanceOf(_ class: String) -> ElementMatcher {
        return IsInstanceMatcher(`class`)
    }
    
    public func isSubviewOf(
        _ matcher: ElementMatcherBuilderClosure)
        -> ElementMatcher
    {
        return IsSubviewMatcher(matcher(self))
    }
    
    public func matchesReference(
        image: UIImage,
        comparator: SnapshotsComparator)
        -> ElementMatcher
    {
        return ReferenceImageMatcher(
            screenshotTaker: screenshotTaker,
            referenceImage: image,
            snapshotsComparator: comparator,
            snapshotsDifferenceAttachmentGenerator: snapshotsDifferenceAttachmentGenerator
        )
    }
    
    public func matchesReference(
        image: UIImage,
        comparatorType: SnapshotsComparatorType)
        -> ElementMatcher
    {
        return matchesReference(
            image: image,
            comparator: snapshotsComparatorFactory.snapshotsComparator(type: comparatorType)
        )
    }
    
    // We were comparing `String` to `String?` before, this is a temporary kludge to achieve same behavior.
    // Before: func a(b: String, c: String?) { return b == c } // if c == nil, then false is returned
    // After: func a(b: String, c: String) { return b == c } // if c is uuid, then false is returned
    private static let valueToMimicComparisonOfStringToNil = "(the value is actually nil) This string is a kludge, it is used as a replacement for nils, because optional matcher builders are not implemented."
}
