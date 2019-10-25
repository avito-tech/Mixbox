import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class XcTestFailureMatcherBuilder {
    let description = PropertyMatcherBuilder("description", \XcTestFailure.description)
    let file = PropertyMatcherBuilder("file", \XcTestFailure.file)
    let line = PropertyMatcherBuilder("line", \XcTestFailure.line)
    let expected = PropertyMatcherBuilder("expected", \XcTestFailure.expected)
}
