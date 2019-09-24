public final class CachingFileUploaderExecutableProvider: FileUploaderExecutableProvider {
    private let fileUploaderExecutableProvider: FileUploaderExecutableProvider
    private var cachedFileUploaderExecutable: String?
    
    public init(fileUploaderExecutableProvider: FileUploaderExecutableProvider) {
        self.fileUploaderExecutableProvider = fileUploaderExecutableProvider
    }
    
    public func fileUploaderExecutable() throws -> String {
        if let cachedFileUploaderExecutable = cachedFileUploaderExecutable {
            return cachedFileUploaderExecutable
        } else {
            let fileUploaderExecutable = try fileUploaderExecutableProvider.fileUploaderExecutable()
            
            cachedFileUploaderExecutable = fileUploaderExecutable
            
            return fileUploaderExecutable
        }
    }
}
