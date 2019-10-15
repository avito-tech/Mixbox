import CiFoundation

public final class TemporaryFileProviderMock: TemporaryFileProvider {
    private let stubbedTemporaryFilePath: String
    
    public init(temporaryFilePath: String) {
        self.stubbedTemporaryFilePath = temporaryFilePath
    }
    
    public func temporaryFilePath() -> String {
        return stubbedTemporaryFilePath
    }
}
