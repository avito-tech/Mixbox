public enum IpcMethodCallingResult: Codable {
    case success
    case failure(String)
    
    // sourcery:inline:auto:IpcMethodCallingResult.Codable
    private enum CodingKeys: String, CodingKey {
        case caseId
        case success
        case failure
    }

    private enum CaseId: String, Codable {
        case success
        case failure
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .success:
            try container.encode(CaseId.success, forKey: .caseId)
        case .failure(let nested):
            try container.encode(CaseId.failure, forKey: .caseId)
            try container.encode(nested, forKey: .failure)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let caseId = try container.decode(CaseId.self, forKey: .caseId)

        switch caseId {
        case .success:
            self = .success
        case .failure:
            let nested = try container.decode(String.self, forKey: .failure)
            self = .failure(nested)
        }
    }
    // sourcery:end
}
