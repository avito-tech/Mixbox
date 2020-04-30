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
        case showKeyboard
        
        public var id: String {
            switch self {
            case let .push(animated):
                return "pushButton_" + (animated ? "animated" : "notAnimated")
            case let .present(animated):
                return "presentButton_" + (animated ? "animated" : "notAnimated")
            case .showKeyboard:
                return "showKeyboard"
            }
        }

// sourcery:inline:auto:WaitingForQuiescenceTestsViewConfiguration.ActionButton.Codable
    private enum CodingKeys: String, CodingKey {
        case caseId
        case push
        case present
        case showKeyboard
    }

    private enum CaseId: String, Codable {
        case push
        case present
        case showKeyboard
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .push(let nested):
            try container.encode(CaseId.push, forKey: .caseId)
            try container.encode(nested, forKey: .push)
        case .present(let nested):
            try container.encode(CaseId.present, forKey: .caseId)
            try container.encode(nested, forKey: .present)
        case .showKeyboard:
            try container.encode(CaseId.showKeyboard, forKey: .showKeyboard)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseId = try container.decode(CaseId.self, forKey: .caseId)

        switch caseId {
        case .push:
            let nested = try container.decode(Bool.self, forKey: .push)
            self = .push(animated: nested)
        case .present:
            let nested = try container.decode(Bool.self, forKey: .present)
            self = .present(animated: nested)
        case .showKeyboard:
            self = .showKeyboard
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
