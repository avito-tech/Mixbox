import Foundation

@objc(PrincipalClass)
final class PrincipalClass: NSObject {

    public override init() {
        super.init()
        main()
    }

    func main() {
        // TODO: Get rid of usage of ProcessInfo singleton here
        let exportPath: String? = ProcessInfo.processInfo.environment["AVITO_TEST_RUNNER_RUNTIME_TESTS_EXPORT_PATH"]

        if let exportPath = exportPath, !exportPath.isEmpty {
            TestQuery(outputPath: exportPath).export()
        }
    }
}
