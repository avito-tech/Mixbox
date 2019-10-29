import Foundation

public protocol FilesEnumerator {
    func enumerateFiles(
        directory: String,
        handler: (_ enumerator: FileManager.DirectoryEnumerator, _ url: String) throws -> ())
        throws
}
