public final class WaitingForQuiescenceTestsViewConfiguration: Codable {
    public final class TapIndicatorButton: Codable {
        public let id: String
        public let offset: CGFloat
        
        public init(
            id: String,
            offset: CGFloat)
        {
            self.id = id
            self.offset = offset
        }
    }
    
    public enum ActionButton: Codable {
        case push(animated: Bool)
        case present(animated: Bool)
        case setContentOffsetAnimated(offset: CGFloat)
        
        public var id: String {
            switch self {
            case let .push(animated):
                return "pushButton_" + (animated ? "animated" : "notAnimated")
            case let .present(animated):
                return "presentButton_" + (animated ? "animated" : "notAnimated")
            case let .setContentOffsetAnimated(offset):
                return "setContentOffset_" + "\(offset)"
            }
        }

// sourcery:inline:auto:WaitingForQuiescenceTestsViewConfiguration.ActionButton.Codable
    private enum CodingKeys: String, CodingKey {
        case caseId
        case data
    }

    private enum CaseId: String, Codable {
        case push
        case present
        case setContentOffsetAnimated
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .push(let nested):
            try container.encode(CaseId.push, forKey: .caseId)
            try container.encode(nested, forKey: .data)
        case .present(let nested):
            try container.encode(CaseId.present, forKey: .caseId)
            try container.encode(nested, forKey: .data)
        case .setContentOffsetAnimated(let nested):
            try container.encode(CaseId.setContentOffsetAnimated, forKey: .caseId)
            try container.encode(nested, forKey: .data)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseId = try container.decode(CaseId.self, forKey: .caseId)

        switch caseId {
        case .push:
            let nested = try container.decode(Bool.self, forKey: .data)
            self = .push(animated: nested)
        case .present:
            let nested = try container.decode(Bool.self, forKey: .data)
            self = .present(animated: nested)
        case .setContentOffsetAnimated:
            let nested = try container.decode(CGFloat.self, forKey: .data)
            self = .setContentOffsetAnimated(offset: nested)
        }
    }
// sourcery:end
    }

    public let contentSize: CGSize
    public let tapIndicatorButtons: [TapIndicatorButton]
    public let actionButtons: [ActionButton]
    
    public init(
        contentSize: CGSize,
        tapIndicatorButtons: [TapIndicatorButton],
        actionButtons: [ActionButton])
    {
        self.contentSize = contentSize
        self.tapIndicatorButtons = tapIndicatorButtons
        self.actionButtons = actionButtons
    }
}
