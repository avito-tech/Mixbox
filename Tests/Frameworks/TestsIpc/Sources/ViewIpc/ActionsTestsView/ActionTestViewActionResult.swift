public enum ActionsTestsViewActionResult: Codable, Equatable, CustomStringConvertible {
    case uiWasTriggered(String)
    case uiWasNotTriggered
    case error(String)
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        switch self {
        case .error(let error):
            return "<ERROR: \(error)>"
        case .uiWasNotTriggered:
            return "<UI WAS NOT TRIGGERED>"
        case .uiWasTriggered(let string):
            return string
        }
    }
    
    // MARK: - Equatable
    
    public static func ==(l: ActionsTestsViewActionResult, r: ActionsTestsViewActionResult) -> Bool {
        switch (l, r) {
        case let (.uiWasTriggered(l), .uiWasTriggered(r)):
            return l == r
        case (.uiWasNotTriggered, .uiWasNotTriggered):
            return  true
        case let (.error(l), .error(r)):
            return l == r
        default:
            return false
        }
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case caseId
        case uiWasTriggered
        case uiWasNotTriggered
        case error
    }
    
    private enum CaseId: String, Codable {
        case uiWasTriggered
        case uiWasNotTriggered
        case error
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .uiWasTriggered(let nested):
            try container.encode(CaseId.uiWasTriggered, forKey: .caseId)
            try container.encode(nested, forKey: .uiWasTriggered)
        case .uiWasNotTriggered:
            try container.encode(CaseId.uiWasNotTriggered, forKey: .caseId)
        case .error(let nested):
            try container.encode(CaseId.error, forKey: .caseId)
            try container.encode(nested, forKey: .error)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseId = try container.decode(CaseId.self, forKey: .caseId)
        
        switch caseId {
        case .uiWasTriggered:
            let nested = try container.decode(String.self, forKey: .uiWasTriggered)
            self = .uiWasTriggered(nested)
        case .uiWasNotTriggered:
            self = .uiWasNotTriggered
        case .error:
            let nested = try container.decode(String.self, forKey: .error)
            self = .error(nested)
        }
    }
}
