public protocol AllureExecutableItem: class, Encodable {
    var name: String? { get }
    var status: AllureStatus { get }
    var statusDetails: AllureStatusDetails? { get }
    var stage: AllureResultStage { get }
    var description: String? { get }
    var descriptionHtml: String? { get }
    var steps: [AllureExecutableItem] { get }
    var start: AllureTimestamp? { get }
    var stop: AllureTimestamp? { get }
    var attachments: [AllureAttachment] { get }
    var parameters: [AllureParameter] { get }
}

