import EarlGrey
import MixboxUiTestsFoundation

public protocol EarlGreyInteraction: Interaction {
    // The fact that this property is exposed
    // is a trade off. It is used in EarlGreyScroller.
    var elementMatcher: GREYMatcher { get }
}
