import CiFoundation
import Foundation

public final class DerivedDataPathProviderImpl: DerivedDataPathProvider {
    private let temporaryFileProvider: TemporaryFileProvider
    
    public init(temporaryFileProvider: TemporaryFileProvider) {
        self.temporaryFileProvider = temporaryFileProvider
    }
    
    public func derivedDataPath() -> String {
        return NSString(string: temporaryFileProvider.temporaryFilePath() + "/dd").standardizingPath
    }
}
