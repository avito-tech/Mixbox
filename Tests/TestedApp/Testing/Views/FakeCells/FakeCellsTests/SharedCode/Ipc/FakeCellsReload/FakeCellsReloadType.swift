public enum FakeCellsReloadType: Codable {
    case reloadData
    case performBatchUpdates(PerformBatchUpdatesStyle)

    public enum PerformBatchUpdatesStyle: String, Codable {
        case deleteAndInsert
        case reload
    }
    
// sourcery:inline:auto:FakeCellsReloadType.Codable
    private enum CodingKeys: String, CodingKey {
        case caseId
        case reloadData
        case performBatchUpdates
    }

    private enum CaseId: String, Codable {
        case reloadData
        case performBatchUpdates
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .reloadData:
            try container.encode(CaseId.reloadData, forKey: .caseId)
        case .performBatchUpdates(let nested):
            try container.encode(CaseId.performBatchUpdates, forKey: .caseId)
            try container.encode(nested, forKey: .performBatchUpdates)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseId = try container.decode(CaseId.self, forKey: .caseId)

        switch caseId {
        case .reloadData:
            self = .reloadData
        case .performBatchUpdates:
            let nested = try container.decode(PerformBatchUpdatesStyle.self, forKey: .performBatchUpdates)
            self = .performBatchUpdates(nested)
        }
    }
// sourcery:end
}
