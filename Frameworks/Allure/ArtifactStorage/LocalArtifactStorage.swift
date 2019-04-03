import Foundation
import MixboxArtifacts

public final class LocalArtifactStorage: ArtifactStorage {
    private let artifactsRootDirectory: String
    
    public init(artifactsRootDirectory: String) {
        self.artifactsRootDirectory = artifactsRootDirectory
    }
    
    // MARK: - ArtifactStorage
    
    public func store(
        artifact: Artifact,
        pathComponents: [String],
        completion: @escaping (ArtifactStorageResult) -> ())
    {
        let result = store(
            artifact: artifact,
            pathComponents: pathComponents
        )
        
        completion(result)
    }
    
    // MARK: - Private
    
    private func store(
        artifact: Artifact,
        pathComponents: [String])
        -> ArtifactStorageResult
    {
        let artifactDirectory = prepareArtifactDirectory(
            pathComponents: pathComponents
        )
        
        let fileName = nonExistingFileName(
            artifactFolder: artifactDirectory,
            artifact: artifact
        )
        
        return store(
            artifact: artifact,
            pathComponents: pathComponents,
            directory: artifactDirectory,
            fileName: fileName
        )
    }
    
    private func prepareArtifactDirectory(pathComponents: [String]) -> String {
        let artifactDirectory = pathComponents.reduce(artifactsRootDirectory) { artifactDirectory, pathComponent in
            (artifactDirectory as NSString).appendingPathComponent(pathComponent)
        }
        
        try? FileManager.default.createDirectory(
            atPath: artifactDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        return artifactDirectory
    }
    
    private func nonExistingFileName(artifactFolder: String, artifact: Artifact) -> String {
        var index: Int?
        
        func fileExists() -> Bool {
            return FileManager.default.fileExists(
                atPath: (artifactFolder as NSString).appendingPathComponent(
                    fileName(
                        artifact: artifact,
                        index: index
                    )
                )
            )
        }
        
        while fileExists() {
            index = index.flatMap { $0 + 1 } ?? 0
        }
        
        return fileName(
            artifact: artifact,
            index: index
        )
    }
    
    private func fileName(artifact: Artifact, index: Int?) -> String {
        let indexComponent = index.flatMap { index in "_\(index)" } ?? ""
        
        let fileExtensionComponent = fileExtension(artifact: artifact)
            .flatMap { fileExtension in ".\(fileExtension)" } ?? ""
        
        return "\(artifact.name)\(indexComponent)\(fileExtensionComponent)"
    }
    
    private func fileExtension(artifact: Artifact) -> String? {
        switch artifact.content {
        case .screenshot:
            return "png"
        case .text:
            return "txt"
        case .json:
            return "json"
        case .artifacts:
            return nil
        }
    }
    
    private func store(
        artifact: Artifact,
        pathComponents: [String],
        directory: String,
        fileName: String)
        -> ArtifactStorageResult
    {
        let path = (directory as NSString).appendingPathComponent(fileName)
        
        switch artifact.content {
        case .screenshot(let screenshot):
            saveImage(image: screenshot, path: path)
        case .text(let string):
            FileManager.default.createFile(
                atPath: path,
                contents: string.data(using: .utf8)
            )
        case .json(let string):
            FileManager.default.createFile(
                atPath: path,
                contents: string.data(using: .utf8)
            )
        case .artifacts(let artifacts):
            for artifact in artifacts {
                store(
                    artifact: artifact,
                    pathComponents: pathComponents + [fileName]
                )
            }
        }
        
        return .stored(path: path)
    }
    
    private func saveImage(image: UIImage, path: String) {
        guard let orientedImage = imageAfterApplyingOrientation(image: image),
            let pngRepresentation = UIImagePNGRepresentation(orientedImage)
            else
        {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        try? pngRepresentation.write(to: url, options: Data.WritingOptions.atomic)
    }
    
    private func imageAfterApplyingOrientation(image: UIImage) -> UIImage? {
        if image.imageOrientation == .up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: imageRect)
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}
