public enum ScrollingHint: Codable {
    // Positive case: should scroll using instructions
    case shouldScroll([DraggingInstruction])
    // Positive case: should not scroll, should reload snapshots inside tests (caches)
    case shouldReloadSnapshots
    
    // Poorly designed case: do nothing, do not scroll. What is poorly designed: how it is handled, there was
    // at least one bug when this case was converted to an error case. And maybe this is because we should rename
    // the case or split it in two. TODO: Review usages, improve if needed.
    case canNotProvideHintForCurrentRequest
    
    // Should use some kind of fallback
    case hintsAreNotAvailableForCurrentElement
    
    // Negative case: error that should fail test
    case internalError(String)
    
    private enum CodingKeys: String, CodingKey {
        case caseId
        case shouldScroll
        case internalError
    }
    
    private enum CaseId: String, Codable {
        case shouldScroll
        case shouldReloadSnapshots
        case canNotProvideHintForCurrentRequest
        case hintsAreNotAvailableForCurrentElement
        case internalError
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .shouldScroll(let nested):
            try container.encode(CaseId.shouldScroll, forKey: .caseId)
            try container.encode(nested, forKey: .shouldScroll)
        case .shouldReloadSnapshots:
            try container.encode(CaseId.shouldReloadSnapshots, forKey: .caseId)
        case .canNotProvideHintForCurrentRequest:
            try container.encode(CaseId.canNotProvideHintForCurrentRequest, forKey: .caseId)
        case .hintsAreNotAvailableForCurrentElement:
            try container.encode(CaseId.hintsAreNotAvailableForCurrentElement, forKey: .caseId)
        case .internalError(let nested):
            try container.encode(CaseId.internalError, forKey: .caseId)
            try container.encode(nested, forKey: .internalError)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseId = try container.decode(CaseId.self, forKey: .caseId)
        
        switch caseId {
        case .shouldScroll:
            let nested = try container.decode([DraggingInstruction].self, forKey: .shouldScroll)
            self = .shouldScroll(nested)
        case .shouldReloadSnapshots:
            self = .shouldReloadSnapshots
        case .canNotProvideHintForCurrentRequest:
            self = .canNotProvideHintForCurrentRequest
        case .hintsAreNotAvailableForCurrentElement:
            self = .hintsAreNotAvailableForCurrentElement
        case .internalError:
            let nested = try container.decode(String.self, forKey: .internalError)
            self = .internalError(nested)
        }
    }
}
