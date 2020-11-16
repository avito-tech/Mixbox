import XCTest
import PathKit
import MixboxMocksGeneration

final class MockGenerationTests: XCTestCase {
    func test() {
        do {
            let parser = SourceFileParserImpl()
            let parsedSourceFile = try parser.parse(
                path: FixturesPath.fixtureProtocolPath,
                moduleName: "FixtureModule"
            )
            let parsedSourceFiles = ParsedSourceFiles(sourceFiles: [parsedSourceFile])
            
            try assertEqualsToFixtureFile(
                actualString: try AllMocksTemplate(parsedSourceFiles: parsedSourceFiles).render(),
                expectedStringFilePath: FixturesPath.fixtureProtocolMockPath
            )
        } catch {
            XCTFail("\(error)")
        }
    }
    
    private func assertEqualsToFixtureFile(actualString: String, expectedStringFilePath: Path) throws {
        let expectedString = try read(path: expectedStringFilePath)
        
        if expectedString != actualString {
            try write(value: actualString, path: expectedStringFilePath)
            
            XCTFail("Fixture differes from expected")
        }
    }
    
    private func write(value: String, path: Path) throws {
        try (value as NSString).write(
            toFile: path.string,
            atomically: true,
            encoding: String.Encoding.utf8.rawValue
        )
    }
    
    private func read(path: Path) throws -> String {
        return try NSString(
            contentsOfFile: path.string,
            encoding: String.Encoding.utf8.rawValue
        ) as String
    }
}
