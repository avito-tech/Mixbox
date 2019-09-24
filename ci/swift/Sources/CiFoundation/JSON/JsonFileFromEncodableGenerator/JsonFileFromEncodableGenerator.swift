public protocol JsonFileFromEncodableGenerator {
    func generateJsonFile<T: Encodable>(encodable: T) throws -> String
}
