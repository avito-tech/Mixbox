import MixboxTestsFoundation

public final class RecordedCallArgumentsMatcher: Matcher<RecordedCallArguments> {
    public init(matchers: [Matcher<RecordedCallArgument>]) {
        super.init(
            description: {
                let matcherDescriptions = matchers
                    .map { "'\($0.description)'" }
                    .joined(separator: ", ")
                
                return "recorded call arguments match matchers [\(matcherDescriptions)]"
            },
            matchingFunction: { recordedCallArguments in
                ArrayEqualsMatcher(matchers: matchers).match(
                    value: recordedCallArguments.arguments
                )
            }
        )
    }
}
