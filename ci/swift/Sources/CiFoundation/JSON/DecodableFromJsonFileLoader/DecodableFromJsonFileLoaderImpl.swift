import Foundation

public final class DecodableFromJsonFileLoaderImpl: DecodableFromJsonFileLoader {
    public init() {
    }
    
    public func load<T: Decodable>(path: String) throws -> T {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONDecoder().decode(T.self, from: data)
    }
}
