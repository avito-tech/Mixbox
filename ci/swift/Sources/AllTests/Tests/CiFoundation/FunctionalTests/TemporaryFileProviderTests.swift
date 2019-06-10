import XCTest
import CiFoundation

final class TemporaryFileProviderTests: XCTestCase {
    func test() {
        let temporaryFileProvider = TemporaryFileProviderImpl()
        let path = temporaryFileProvider.temporaryFilePath()
        
        XCTAssert(!FileManager.default.fileExists(atPath: path))
        
        try? "anything".write(toFile: path, atomically: true, encoding: .utf8)
        
        XCTAssert(FileManager.default.fileExists(atPath: path))
        
        try? FileManager.default.removeItem(atPath: path)
    }
}
