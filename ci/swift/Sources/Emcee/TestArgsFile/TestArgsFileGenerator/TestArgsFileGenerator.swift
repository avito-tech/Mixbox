import Models

public protocol TestArgFileGenerator {
    func testArgFile(
        arguments: TestArgFileGeneratorArguments)
        throws
        -> TestArgFile
}
