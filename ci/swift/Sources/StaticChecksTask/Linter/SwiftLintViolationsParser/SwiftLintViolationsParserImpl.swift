import Foundation
import CiFoundation

public final class SwiftLintViolationsParserImpl: SwiftLintViolationsParser {
    public init() {
    }
    
    public func parseViolations(
        stdout: String)
        throws
        -> [SwiftLintViolation]
    {
        // Example: /path/to/repo/root/Package.swift:8:76: warning: Trailing Comma Violation: Collection literals should not have trailing commas. (trailing_comma)
        let regex = try NSRegularExpression(
            pattern: "^(.*?):(\\d+):(\\d+): (warning|error): (.*?) \\((.*?)\\)$",
            options: [.anchorsMatchLines]
        )
        
        return try regex.matchesIn(string: stdout).map(violation)
    }
    
    private func violation(
        match: [String])
        throws
        -> SwiftLintViolation
    {
        guard match.count == 7 else {
            throw ErrorString("Failed to parse SwiftLintViolation from regex match \(match)")
        }
        
        return SwiftLintViolation(
            file: match[1],
            line: try Int(match[2]).unwrapOrThrow(),
            column: try Int(match[3]).unwrapOrThrow(),
            type: try SwiftLintViolationType(rawValue: match[4]).unwrapOrThrow(),
            description: match[5],
            rule: match[6]
        )
    }
}

private extension NSRegularExpression {
    func matchesIn(string: String) -> [[String]] {
        let matches = self.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        
        return matches.map { match in
            (0..<match.numberOfRanges).map { rangeIndex in
                let range = match.range(at: rangeIndex)
                
                return String(string.utf16.prefix(range.location + range.length).suffix(range.length)) ?? ""
            }
        }
    }
}
