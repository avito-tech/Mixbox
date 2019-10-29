import Foundation

public final class MixboxFrameworksEnumeratorImpl: MixboxFrameworksEnumerator {
    private let filesEnumerator: FilesEnumerator
    private let frameworksDirectoryProvider: FrameworksDirectoryProvider
    
    public init(
        filesEnumerator: FilesEnumerator,
        frameworksDirectoryProvider: FrameworksDirectoryProvider)
    {
        self.filesEnumerator = filesEnumerator
        self.frameworksDirectoryProvider = frameworksDirectoryProvider
    }
    
    public func enumerateFrameworks(
        handler: (_ frameworkDirectory: String, _ frameworkName: String) throws -> ())
        throws
    {
        try filesEnumerator.enumerateFiles(
            directory: frameworksDirectoryProvider.frameworksDirectory(),
            handler: { enumerator, path in
                var isDirectory: ObjCBool = false
                
                if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        let frameworkName = (path as NSString).lastPathComponent
                        
                        try handler(path, frameworkName)
                    }
                }
                
                enumerator.skipDescendants()
            }
        )
    }
}
