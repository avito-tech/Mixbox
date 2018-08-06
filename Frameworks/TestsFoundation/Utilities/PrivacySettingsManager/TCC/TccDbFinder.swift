import MixboxFoundation

// Searches for TCC.db of current simulator
final class TccDbFinder {
    func tccDbPath() -> String? {
        guard let appDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            .first?
            .mb_deletingLastPathComponent
            else
        {
            return nil
        }
        
        return find(file: "data/Library/TCC/TCC.db", inParentDirectoryOf: appDirectory)
    }
    
    private func find(file: String, inParentDirectoryOf sourceDirectory: String) -> String? {
        var directoryPointer = sourceDirectory
        var pathComponentsReversed = [String]()
        
        while directoryPointer.contains("/") {
            do {
                var isDirectory: ObjCBool = false
                let filePath = directoryPointer + "/" + file
                let exists = try FileManager.default.fileExists(
                    atPath: filePath,
                    isDirectory: &isDirectory
                )
                
                if exists && !isDirectory.boolValue {
                    return filePath
                }
            } catch {
            }
            directoryPointer = directoryPointer.mb_deletingLastPathComponent
        }
        
        return nil
    }
}
