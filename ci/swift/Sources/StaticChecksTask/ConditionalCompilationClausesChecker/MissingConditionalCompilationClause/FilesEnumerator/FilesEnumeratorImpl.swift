import Foundation
import CiFoundation

public final class FilesEnumeratorImpl: FilesEnumerator {
    public init() {
    }
    
    public func enumerateFiles(
        directory: String,
        handler: (_ enumerator: FileManager.DirectoryEnumerator, _ url: String) throws -> ())
        throws
    {
        if let enumerator = FileManager.default.enumerator(atPath: directory) {
            for case let path as String in enumerator {
                try handler(enumerator, "\(directory)/\(path)")
            }
        } else {
            throw ErrorString("Failed to create enumerator of directory \(directory)")
        }
    }
}
