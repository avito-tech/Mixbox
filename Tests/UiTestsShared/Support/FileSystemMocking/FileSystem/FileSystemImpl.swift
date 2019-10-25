import MixboxTestsFoundation

final class FileSystemImpl: FileSystem {
    private let fileManager: FileManager
    private let temporaryDirectoryPathProvider: TemporaryDirectoryPathProvider
    private var createdInstances = [Any]()
    
    init(
        fileManager: FileManager,
        temporaryDirectoryPathProvider: TemporaryDirectoryPathProvider)
    {
        self.fileManager = fileManager
        self.temporaryDirectoryPathProvider = temporaryDirectoryPathProvider
    }
    
    func temporaryFile(name: String?) -> TemporaryFile {
        return createTemporaryFileSystemEntity(
            entityCreationClosure: {
                createTemporaryFileAndReturnPath(fileName: name)
            },
            objectCreationClosure: { path in
                CreatedTemporaryFile(
                    path: path,
                    fileManager: fileManager
                )
            }
        )
    }
    
    func temporaryDirectory(name: String?) -> TemporaryDirectory {
        return createTemporaryFileSystemEntity(
            entityCreationClosure: {
                createTemporaryDirectoryAndReturnPath(fileName: name)
            },
            objectCreationClosure: { path in
                CreatedTemporaryDirectory(
                    path: path,
                    fileManager: fileManager
                )
            }
        )
    }
    
    private func createTemporaryFileSystemEntity<T>(
        entityCreationClosure: () -> String?,
        objectCreationClosure: (String) -> T,
        maxAttempts: Int = 3)
        -> T
    {
        let fileOrNil = (0..<maxAttempts)
            .map { _ in entityCreationClosure() }
            .compactMap { $0 }
            .first
            .map { path in
                objectCreationClosure(path)
            }
        
        guard let file = fileOrNil else {
            UnavoidableFailure.fail("Couldn't create temporary file after \(maxAttempts) attempts")
        }
        
        createdInstances.append(temporaryFile)
        
        return file
    }
    
    private func createTemporaryFileAndReturnPath(fileName: String?) -> String? {
        let path = temporaryFileSystemEntityPath(fileName: fileName)
        
        let created = fileManager.createFile(
            atPath: path,
            contents: nil,
            attributes: [:]
        )
        
        return created
            ? path
            : nil
    }
    
    private func createTemporaryDirectoryAndReturnPath(fileName: String?) -> String? {
        let path = temporaryFileSystemEntityPath(fileName: fileName)
        
        do {
            try fileManager.createDirectory(
                atPath: path,
                withIntermediateDirectories: true,
                attributes: nil
            )
            
            return path
        } catch {
            return nil
        }
    }
    
    private func temporaryFileSystemEntityPath(fileName: String?) -> String {
        return temporaryDirectoryPathProvider
            .temporaryDirectoryPath()
            .mb_appendingPathComponent(fileName ?? fileNameForTemporaryFileSystemEntity())
    }
    
    private func fileNameForTemporaryFileSystemEntity() -> String {
        return UUID().uuidString
    }
}
