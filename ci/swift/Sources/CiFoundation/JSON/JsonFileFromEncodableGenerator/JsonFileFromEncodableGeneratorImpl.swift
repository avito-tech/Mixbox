import Foundation

public final class JsonFileFromEncodableGeneratorImpl: JsonFileFromEncodableGenerator {
    private let temporaryFileProvider: TemporaryFileProvider
    
    public init(temporaryFileProvider: TemporaryFileProvider) {
        self.temporaryFileProvider = temporaryFileProvider
    }
    
    public func generateJsonFile<T: Encodable>(encodable: T) throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(encodable)
        
        let temporaryFilePath = temporaryFileProvider.temporaryFilePath()
        try data.write(to: URL(fileURLWithPath: temporaryFilePath), options: .atomicWrite)
        
        return temporaryFilePath
    }
}
