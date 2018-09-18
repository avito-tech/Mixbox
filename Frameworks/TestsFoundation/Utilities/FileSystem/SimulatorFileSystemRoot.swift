import MixboxFoundation

public final class SimulatorFileSystemRoot {
    // TODO: Remove singleton
    public static var current: SimulatorFileSystemRoot? = makeCurrent()
    
    public let osxRoot: String
    
    public init(osxRoot: String) {
        self.osxRoot = osxRoot
    }
    
    // Finds file in simulator.
    // Example of `pathRelativeToSimulator`: "data/Documents".
    public func osxPath(_ pathRelativeToSimulator: String) -> String {
        return osxRoot.mb_appendingPathComponent(pathRelativeToSimulator)
    }
    
    private static func makeCurrent() -> SimulatorFileSystemRoot? {
        let anyExistingFile = "data/Library/TCC/TCC.db"
        
        guard let applicationDirectory = CurrentApplicationDirectoryProvider.currentApplicationDirectory else {
            return nil
        }
        
        guard let anyExistingFileOsxPath = find(
            file: anyExistingFile,
            inParentDirectoryOf: applicationDirectory) else
        {
            return nil
        }
        
        // Example:
        // anyExistingFile = b/c
        // anyExistingFileOsxPath = /a/b/c
        // osxRoot = /a/
        let osxRoot = String(anyExistingFileOsxPath.prefix(anyExistingFileOsxPath.count - anyExistingFile.count))
        
        return SimulatorFileSystemRoot(osxRoot: osxRoot)
    }
    
    private static func find(file: String, inParentDirectoryOf sourceDirectory: String) -> String? {
        var directoryPointer = sourceDirectory
        
        while directoryPointer.contains("/") {
            var isDirectory: ObjCBool = false
            let filePath = directoryPointer + "/" + file
            let exists = FileManager.default.fileExists(
                atPath: filePath,
                isDirectory: &isDirectory
            )
            
            if exists && !isDirectory.boolValue {
                return filePath
            }
            
            let newDirectoryPointer = directoryPointer.mb_deletingLastPathComponent
            
            if newDirectoryPointer == directoryPointer {
                break
            }
            
            directoryPointer = newDirectoryPointer
        }
        
        return nil
    }
}
