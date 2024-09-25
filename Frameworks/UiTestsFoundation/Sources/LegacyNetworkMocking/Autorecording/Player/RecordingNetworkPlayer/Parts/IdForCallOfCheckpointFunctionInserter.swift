import Foundation
import MixboxFoundation

final class IdForCallOfCheckpointFunctionInserter {
    private let encoding = String.Encoding.utf8
    
    func insertIdForCallOfCheckpointFunction(
        id: String,
        fileLine: RuntimeFileLine)
        throws
    {
        let (file, lineNumber) = try fileAndLineNumberStartingFromZero(fileLine: fileLine)
        
        let sourceLines = try readLines(file: file)
        let patchedLines = try patchLines(
            lines: sourceLines,
            id: id,
            lineNumber: lineNumber
        )
        
        try writeLines(
            lines: patchedLines,
            file: file
        )
    }
    
    private func patchLines(
        lines: [String],
        id: String,
        lineNumber: UInt)
        throws
        -> [String]
    {
        guard let intLineNumber = Int(exactly: lineNumber) else {
            return lines
        }
        
        var lines = lines
        let regex = try NSRegularExpression(pattern: "(\\.checkpoint)\\((?:|id: \".*?\")\\)", options: [])
        
        lines[intLineNumber] = regex.stringByReplacingMatches(
            in: lines[intLineNumber],
            options: [],
            range: NSRange(location: 0, length: (lines[intLineNumber] as NSString).length),
            withTemplate: "$1(id: \"\(id)\")"
        )
        
        return lines
    }
    
    private func readLines(
        file: String)
        throws
        -> [String]
    {
        let string = try NSString(contentsOfFile: file, encoding: encoding.rawValue) as String
        
        return string
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { String($0) }
    }
    
    private func writeLines(
        lines: [String],
        file: String)
        throws
    {
        try (lines.joined(separator: "\n") as NSString)
            .write(toFile: file, atomically: true, encoding: encoding.rawValue)
    }
    
    private func fileAndLineNumberStartingFromZero(
        fileLine: RuntimeFileLine)
        throws
        -> (file: String, line: UInt)
    {
        guard fileLine.line >= 1 else {
            throw ErrorString("Line \(fileLine.line) < 1, which is unexpected. Note that lines in file starts with 1 instead of 0.")
        }
        
        let line = fileLine.line - 1
        let file = fileLine.file
        
        return (file, line)
    }
}
