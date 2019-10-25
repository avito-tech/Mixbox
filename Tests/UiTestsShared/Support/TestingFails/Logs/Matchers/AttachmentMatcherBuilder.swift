import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class AttachmentMatcherBuilder {
    let name = PropertyMatcherBuilder("name", \Attachment.name)
    let content = PropertyMatcherBuilder("content", \Attachment.content)
}
