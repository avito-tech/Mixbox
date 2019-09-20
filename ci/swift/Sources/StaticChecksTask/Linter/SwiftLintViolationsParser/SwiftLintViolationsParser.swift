public protocol SwiftLintViolationsParser {
    func parseViolations(stdout: String) throws -> [SwiftLintViolation]
}
