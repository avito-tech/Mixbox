import XCTest
import PathKit
import MixboxMocksGeneration

final class MockGenerationTests: XCTestCase {
    func test() {
        do {
            let moduleName = "UnitTests"
            let parser = SourceFileParserImpl()
            
            let parsedSourceFiles = ParsedSourceFiles(
                sourceFiles: try FixturesPathsForOsxUnitTests.allFiles.map {
                    try parser.parse(
                        path: $0,
                        moduleName: moduleName
                    )
                }
            )
            
            let template = AllMocksTemplate(
                parsedSourceFiles: parsedSourceFiles,
                destinationModuleName: moduleName
            )
            
            _ = try template.render()
        } catch {
            XCTFail("\(error)")
        }
    }
    
    private func read(path: Path) throws -> String {
        return try NSString(
            contentsOfFile: path.string,
            encoding: String.Encoding.utf8.rawValue
        ) as String
    }
}
