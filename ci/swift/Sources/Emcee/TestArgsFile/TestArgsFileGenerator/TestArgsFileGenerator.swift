import TestArgFile

public protocol TestArgFileGenerator {
    func testArgFile(
        arguments: TestArgFileGeneratorArguments)
        throws
    -> TestArgFile<AppleTestArgFileEntry>
}
