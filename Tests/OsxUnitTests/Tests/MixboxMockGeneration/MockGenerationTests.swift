import XCTest
import PathKit
import MixboxMocksGeneration

final class MockGenerationTests: XCTestCase {
    func test() {
        do {
            let moduleName = "UnitTests"
            let parser = ModuleParserImpl(
                sourceFileParser: SourceFileParserImpl()
            )
            
            let parsedModule = try parser.parse(
                paths: FixturesPathsForOsxUnitTests.allFiles(),
                moduleName: moduleName
            )
            
            let template = AllMocksTemplate(
                parsedModule: parsedModule,
                destinationModuleName: moduleName
            )
            
            _ = template.render()
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
