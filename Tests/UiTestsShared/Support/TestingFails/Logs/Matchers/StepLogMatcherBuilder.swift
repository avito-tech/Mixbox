import MixboxTestsFoundation
import MixboxUiTestsFoundation

final class StepLogMatcherBuilder {
    let title = PropertyMatcherBuilder("title", \StepLog.title)
    let startDate = PropertyMatcherBuilder("startDate", \StepLog.startDate)
    let stopDate = PropertyMatcherBuilder("stopDate", \StepLog.stopDate)
    let wasSuccessful = PropertyMatcherBuilder("wasSuccessful", \StepLog.wasSuccessful)
    
    let attachmentsBefore = ArrayPropertyMatcherBuilder<StepLog, Attachment, AttachmentMatcherBuilder>(
        propertyName: "attachmentsBefore",
        propertyKeyPath: \StepLog.attachmentsBefore,
        matcherBuilder: AttachmentMatcherBuilder()
    )
    
    let attachmentsAfter = ArrayPropertyMatcherBuilder<StepLog, Attachment, AttachmentMatcherBuilder>(
        propertyName: "attachmentsAfter",
        propertyKeyPath: \StepLog.attachmentsAfter,
        matcherBuilder: AttachmentMatcherBuilder()
    )
    
    let steps = ArrayPropertyMatcherBuilder<StepLog, StepLog, StepLogMatcherBuilder>(
        propertyName: "steps",
        propertyKeyPath: \StepLog.steps,
        matcherBuilder: StepLogMatcherBuilder()
    )
}
