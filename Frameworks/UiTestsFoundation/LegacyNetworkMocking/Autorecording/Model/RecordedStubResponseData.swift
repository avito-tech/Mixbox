import MixboxAnyCodable

public enum RecordedStubResponseData: Codable, Equatable {
    // Case `data` is enough for everything, however, json was added for readability.
    // E.g.: if `RecordedStubResponseData` is serialized to JSON and data is also JSON,
    // then serialized `RecordedStubResponseData` will be just JSON, easy to read and modify.
    // TODO: Maybe to add `string` case for HTML or something else representable by string.
    case data(Data)
    case json([String: AnyCodable])
    
    public func data() throws -> Data {
        switch self {
        case .data(let data):
            return data
        case .json(let json):
            return try JSONEncoder().encode(json)
        }
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    private enum ValueType: String, Codable {
        case data
        case json
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .data(let data):
            try container.encode(ValueType.data, forKey: CodingKeys.type)
            try container.encode(data, forKey: CodingKeys.value)
        case .json(let json):
            try container.encode(ValueType.json, forKey: CodingKeys.type)
            try container.encode(json, forKey: CodingKeys.value)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ValueType.self, forKey: .type)
        
        switch type {
        case .json:
            let json = try container.decode([String: AnyCodable].self, forKey: CodingKeys.value)
            self = .json(json)
        case .data:
            let data = try container.decode(Data.self, forKey: CodingKeys.value)
            self = .data(data)
        }
    }
    
    // MARK: - Equatable
    
    public static func ==(
        l: RecordedStubResponseData,
        r: RecordedStubResponseData)
        -> Bool
    {
        switch (l, r) {
        case let (.data(l), .data(r)):
            return l == r
        case (.json, .json):
            do {
                // Obviously, this doesn't work well. [String: Any] is an unordered structure.
                return (try l.data()) == (try r.data())
            } catch {
                return false
            }
        default:
            return false
        }
    }
}
