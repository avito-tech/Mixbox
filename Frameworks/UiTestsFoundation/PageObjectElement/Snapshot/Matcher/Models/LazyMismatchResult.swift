import MixboxTestsFoundation

// Generating `mismatchDescription` can be a very time-consuming operation.
// And MismatchResult is produced almost for every element in hierarchy (e.g. if ElementSnapshot is matched),
// and element hierarchy can be matched several times during a check.
// Most of the times the values are not used.
public final class LazyMismatchResult: MismatchResult {
    public let percentageOfMatching: Double
    public private(set) lazy var mismatchDescription: String = mismatchDescriptionFactory()
    public private(set) lazy var attachments: [Attachment] = attachmentsFactory()
    
    private let mismatchDescriptionFactory: () -> String
    private let attachmentsFactory: () -> [Attachment]
    
    public init(
        percentageOfMatching: Double,
        mismatchDescriptionFactory: @escaping () -> String,
        attachmentsFactory: @escaping () -> [Attachment])
    {
        self.percentageOfMatching = percentageOfMatching
        self.mismatchDescriptionFactory = mismatchDescriptionFactory
        self.attachmentsFactory = attachmentsFactory
    }
    
    public static func partialMismatch(
        percentageOfMatching: Double,
        mismatchDescription: @escaping () -> String,
        attachments: @escaping () -> [Attachment])
        -> LazyMismatchResult
    {
        return LazyMismatchResult(
            percentageOfMatching: percentageOfMatching,
            mismatchDescriptionFactory: mismatchDescription,
            attachmentsFactory: attachments
        )
    }
    
    public static func exactMismatch(
        mismatchDescription: @escaping () -> String,
        attachments: @escaping () -> [Attachment])
        -> LazyMismatchResult
    {
        return LazyMismatchResult(
            percentageOfMatching: MatchingResult.exactMismatchPercentage,
            mismatchDescriptionFactory: mismatchDescription,
            attachmentsFactory: attachments
        )
    }
}
