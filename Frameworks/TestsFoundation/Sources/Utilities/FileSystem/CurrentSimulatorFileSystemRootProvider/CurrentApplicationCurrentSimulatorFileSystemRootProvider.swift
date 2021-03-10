import MixboxFoundation

public final class CurrentApplicationCurrentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider {
    public init() {
    }
    
    public func currentSimulatorFileSystemRoot() throws -> SimulatorFileSystemRoot {
        do {
            let anyExistingFile = "data/Library/TCC/TCC.db"
            
            guard let applicationDirectory = currentApplicationDirectory else {
                throw ErrorString("Failed to get currentApplicationDirectory")
            }
            
            guard let anyExistingFileOsxPath = find(
                file: anyExistingFile,
                inParentDirectoryOf: applicationDirectory) else
            {
                throw ErrorString("Failed to verify simulator root by checking for notoriously known file, file doesn't exist: \(anyExistingFile) anywhere in parent directory of \(applicationDirectory). This may occur if this file stopped being present since this version of iOS, in this case fixing Mixbox is required.")
            }
            
            // Example:
            // anyExistingFile = b/c
            // anyExistingFileOsxPath = /a/b/c
            // osxRoot = /a/
            let osxRoot = String(anyExistingFileOsxPath.prefix(anyExistingFileOsxPath.count - anyExistingFile.count))
            
            return SimulatorFileSystemRoot(osxRoot: osxRoot)
        } catch {
            throw ErrorString("Failed to get currentSimulatorFileSystemRoot: \(error)")
        }
    }
    
    private let currentApplicationDirectory: String? = {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            .first?
            .mb_deletingLastPathComponent
    }()
    
    private func find(file: String, inParentDirectoryOf sourceDirectory: String) -> String? {
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
