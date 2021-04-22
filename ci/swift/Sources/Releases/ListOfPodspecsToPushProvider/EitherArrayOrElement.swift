public enum EitherArrayOrElement<T: Codable>: Codable {
    case array([T])
    case element(T)
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .array(let codable):
            try codable.encode(to: encoder)
        case .element(let codable):
            try codable.encode(to: encoder)
        }
    }
    
    public init(from decoder: Decoder) throws {
        do {
            self = .array(try [T](from: decoder))
        } catch {
            self = .element(try T(from: decoder))
        }
    }
}
