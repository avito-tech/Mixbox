public protocol DecodableFromJsonFileLoader {
    func load<T: Decodable>(path: String) throws -> T
}
