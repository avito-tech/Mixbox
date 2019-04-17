import MixboxTestsFoundation

public protocol TemporaryFile {
    var path: String { get }
}

extension TemporaryFile {
    public func withContents(string: String) -> Self {
        do {
            try string.write(toFile: path, atomically: true, encoding: .utf8)
        } catch let e {
            UnavoidableFailure.fail("Failed to write to file: \(e)")
        }
        return self
    }
    
    public var contents: String? {
        return try? String(contentsOfFile: path)
    }
}
