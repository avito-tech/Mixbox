import Models
import Foundation

public protocol TestArgFileJsonGenerator {
    func testArgFile(
        arguments: TestArgFileGeneratorArguments)
        throws
        -> String
}
