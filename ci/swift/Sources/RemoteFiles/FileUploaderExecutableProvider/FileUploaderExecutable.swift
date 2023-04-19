import FileSystem
import PathLib

public final class FileUploaderExecutable {
    public let path: AbsolutePath
    
    private let pathDeleter: PathDeleter
    
    public init(
        path: AbsolutePath,
        pathDeleter: PathDeleter
    ) {
        self.path = path
        self.pathDeleter = pathDeleter
    }
    
    deinit {
        try? pathDeleter.delete(path: path)
    }
}
