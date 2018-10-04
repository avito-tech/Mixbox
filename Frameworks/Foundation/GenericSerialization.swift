// Silly utility.
// Converts anything to string and back.
// Note that serialization method is not specified. The only thing
// you should expect is that you can decode encoded object and get the same object.
public final class GenericSerialization {
    public static func serialize<T: Codable>(value: T) -> String? {
        let encoder = JSONEncoder()
        
        encoder.nonConformingFloatEncodingStrategy = .convertToString(
            positiveInfinity: "+inf",
            negativeInfinity: "-inf",
            nan: "nan"
        )
        
        return serialize(value: value, encoder: encoder)
    }
    
    public static func serialize<T: Codable>(value: T, encoder: JSONEncoder) -> String? {
        guard let data = try? encoder.encode(Container(value: value)) else {
            return nil
        }
        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    public static func deserialize<T: Codable>(string: String) -> T? {
        let decoder = JSONDecoder()
        
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "+inf",
            negativeInfinity: "-inf",
            nan: "nan"
        )
        
        return deserialize(string: string, decoder: decoder)
    }
    
    public static func deserialize<T: Codable>(string: String, decoder: JSONDecoder) -> T? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        return try? decoder.decode(Container<T>.self, from: data).value
    }
}

private class Container<T: Codable>: Codable {
    let value: T
    
    init(value: T) {
        self.value = value
    }
}
