import MixboxTestsFoundation

public protocol MismatchResult {
    // This property is called often:
    var percentageOfMatching: Double { get }
    
    // These properties are called rarely (e.g. when test failure is produced):
    var mismatchDescription: String { get }
    var attachments: [Attachment] { get }
}
