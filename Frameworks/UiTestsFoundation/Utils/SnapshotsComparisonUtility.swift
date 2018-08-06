import UIKit
import MixboxUiKit

// TODO: diff in result
public enum SnapshotUtilityResult {
    case passed
    case failed(String)
}

// TODO: SRP, better interface
public protocol SnapshotsComparisonUtility {
    func compare(actual: UIImage, reference: UIImage) -> SnapshotUtilityResult
    func compare(actual: UIImage, folder: String, file: String) -> SnapshotUtilityResult
}

// TODO: SRP, configurable paths
public final class SnapshotsComparisonUtilityImpl: SnapshotsComparisonUtility {
    
    // MARK: - Paths
    private let basePath: String
    
    // MARK: - Init
    public init(basePath: String) {
        self.basePath = basePath
    }
    
    // MARK: - Interface
    public func compare(actual: UIImage, folder: String, file: String) -> SnapshotUtilityResult {
        let paths = self.paths(folder: folder, file: file)
        
        do {
            guard isImageExists(at: paths.reference) else {
                try save(actual, to: paths.reference)
                return .failed("No reference snapshot named \(file). Created a new one.")
            }
            
            guard let reference = try load(at: paths.reference) else {
                return .failed("Could not load reference image for snapshot named \(file)")
            }
            
            if reference.perPixelEquals(to: actual) {
                return .passed
            }
            
            try save(actual, to: paths.actual)
            
            if let difference = reference.difference(with: actual) {
                try save(difference, to: paths.difference)
            }
            
            return .failed("Snapshot \(file) differs from reference")
        } catch {
            let description = "Could not save snapshot named \(file). Error: \(String(describing: error))"
            return .failed(description)
        }
    }
    
    public func compare(actual: UIImage, reference: UIImage) -> SnapshotUtilityResult {
        if reference.perPixelEquals(to: actual) {
            return .passed
        } else {
            return .failed("Actual snapshot differs from reference")
        }
    }
    
    // MARK: - Private
    private func paths(folder: String, file snapshotName: String) -> (reference: URL, actual: URL, difference: URL) {
        let url = screenshotsURL(folder: folder)
        createDirectoryIfNeeded(at: url)
        
        let reference = url.appendingPathComponent("\(snapshotName).png")
        let actual = url.appendingPathComponent("\(snapshotName).actual.png")
        let difference = url.appendingPathComponent("\(snapshotName)_diff.actual.png")
        
        return (reference, actual, difference)
    }
    
    private func createDirectoryIfNeeded(at url: URL) {
        try? FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    private func screenshotsURL(folder: String) -> URL {
        return URL(fileURLWithPath: basePath)
            .appendingPathComponent(folder)
            .appendingPathComponent(UIDevice.mb_platformType.rawValue)
            .appendingPathComponent(UIDevice.current.mb_iosVersion.majorAndMinor)
    }
    
    private func isImageExists(at url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    private func load(at url: URL) throws -> UIImage? {
        let data = try Data(contentsOf: url)
        return UIImage(data: data, scale: UIScreen.main.scale)
    }
    
    private func save(_ image: UIImage, to url: URL) throws {
        try UIImagePNGRepresentation(image)?.write(to: url, options: [.atomic])
    }
}
