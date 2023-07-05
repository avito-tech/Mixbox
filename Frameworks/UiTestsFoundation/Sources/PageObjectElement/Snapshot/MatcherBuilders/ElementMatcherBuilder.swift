import MixboxTestsFoundation

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
//         && element.accessibilityLabel == "Next keyboard"
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
    private let elementImageProvider: ElementImageProvider
    private let snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator
    private let snapshotsComparatorFactory: SnapshotsComparatorFactory
    
    public init(
        elementImageProvider: ElementImageProvider,
        snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator,
        snapshotsComparatorFactory: SnapshotsComparatorFactory)
    {
        self.elementImageProvider = elementImageProvider
        self.snapshotsDifferenceAttachmentGenerator = snapshotsDifferenceAttachmentGenerator
        self.snapshotsComparatorFactory = snapshotsComparatorFactory
    }
    
    public let frame = CGRectPropertyMatcherBuilder("frame") { (snapshot: ElementSnapshot) -> CGRect in
        // TODO: Support unavailable values
        snapshot.frame.valueIfAvailable ?? .null
    }
    
    public let frameRelativeToScreen = CGRectPropertyMatcherBuilder("frameRelativeToScreen", \ElementSnapshot.frameRelativeToScreen)
    
    public let id = PropertyMatcherBuilder("id", \ElementSnapshot.accessibilityIdentifier)
    
    public let accessibilityLabel = PropertyMatcherBuilder("label", \ElementSnapshot.accessibilityLabel)
    
    public let hasKeyboardFocus = PropertyMatcherBuilder("hasKeyboardFocus", \ElementSnapshot.hasKeyboardFocus)

    public let accessibilityValue = PropertyMatcherBuilder<ElementSnapshot, String>("value") { (snapshot: ElementSnapshot) -> String in
        // TODO: Support nils and other types
        (snapshot.accessibilityValue as? String) ?? ElementMatcherBuilder.valueToMimicComparisonOfStringToNil
    }
    
    public let accessibilityPlaceholderValue = PropertyMatcherBuilder<ElementSnapshot, String>("placeholderValue") {
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
        return IsInstanceElementSnapshotMatcher("\(`class`)")
    }
    
    public func isInstanceOf(_ class: String) -> ElementMatcher {
        return IsInstanceElementSnapshotMatcher(`class`)
    }
    
    public func isSubviewOf(
        matcher: ElementMatcherBuilderClosure)
        -> ElementMatcher
    {
        return IsSubviewMatcher(matcher(self))
    }
    
    public func isDirectSubviewOf(
        matcher: ElementMatcherBuilderClosure)
        -> ElementMatcher
    {
        return HasPropertyMatcher(
            property: { (snapshot: ElementSnapshot) -> ElementSnapshot? in
                snapshot.parent
            },
            name: "superview",
            matcher: OptionalMatcher(matcher(self))
        )
    }
    
    // Matches only direct subviews
    public func hasDirectSubview(
        includingRootSnapshot: Bool = false,
        depthRelativeToDirectSubviews: UInt = 0,
        matcher: ElementMatcherBuilderClosure)
        -> ElementMatcher
    {
        return SnapshotHierarchyMatcher(
            matcher: matcher(self),
            snapshotTreeDepthRange: .forDirectSubviewsMatching(
                includingRootSnapshot: includingRootSnapshot,
                depthRelativeToDirectSubviews: depthRelativeToDirectSubviews
            )
        )
    }
    
    // Recursive matcher
    public func hasSubview(
        includingRootSnapshot: Bool = false,
        matcher: ElementMatcherBuilderClosure)
        -> ElementMatcher
    {
        return SnapshotHierarchyMatcher(
            matcher: matcher(self),
            snapshotTreeDepthRange: .forRecursiveMatching(
                includingRootSnapshot: includingRootSnapshot
            )
        )
    }
    
    // Recursive matcher including root element
    public func matchesOrHasSubviewThatMatches(
        matcher: ElementMatcherBuilderClosure)
        -> ElementMatcher
    {
        return hasSubview(
            includingRootSnapshot: true,
            matcher: matcher
        )
    }
    
    public var hasNoSuperview: ElementMatcher {
        return HasNoSuperviewMatcher()
    }
    
    public func matchesReference(
        image: UIImage,
        comparator: SnapshotsComparator)
        -> ElementMatcher
    {
        return ReferenceImageMatcher(
            elementImageProvider: elementImageProvider,
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
    private static var valueToMimicComparisonOfStringToNil: String {
        "(the value is actually nil) This string is a kludge, it is used as a replacement for nils, because optional matcher builders are not implemented."
    }
}
