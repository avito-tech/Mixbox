import CiFoundation
import Models
import Foundation

public final class TestArgFileJsonGeneratorImpl: TestArgFileJsonGenerator {
    private let testArgFileGenerator: TestArgFileGenerator
    private let jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator
    
    public init(
        testArgFileGenerator: TestArgFileGenerator,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator)
    {
        self.testArgFileGenerator = testArgFileGenerator
        self.jsonFileFromEncodableGenerator = jsonFileFromEncodableGenerator
    }
    
    public func testArgFile(
        arguments: TestArgFileGeneratorArguments)
        throws
        -> String
    {
        return try jsonFileFromEncodableGenerator.generateJsonFile(
            encodable: try testArgFileGenerator.testArgFile(arguments: arguments)
        )
    }
}
