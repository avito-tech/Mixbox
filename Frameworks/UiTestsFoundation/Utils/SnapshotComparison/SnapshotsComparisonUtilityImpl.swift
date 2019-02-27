import MixboxFoundation

// TODO: SRP, configurable paths
public final class SnapshotsComparisonUtilityImpl: SnapshotsComparisonUtility {
    
    // MARK: - Paths
    private let basePath: String
    
    // MARK: - Init
    public init(basePath: String) {
        self.basePath = basePath
    }
    
    // MARK: - Interface
    public func compare(
        actual: UIImage,
        folder: String,
        file: String,
        comparator: SnapshotsComparator)
        -> SnapshotsComparisonResult
    {
        let paths = self.paths(folder: folder, file: file)
        
        func failure(
            _ message: String,
            expected: UIImage? = nil,
            difference: UIImage? = nil)
            -> SnapshotsComparisonResult
        {
            return .failed(
                SnapshotsComparisonFailure(
                    message: message,
                    expectedImage: expected,
                    actualImage: actual,
                    differenceImage: difference
                )
            )
        }
        
        guard isImageExists(at: paths.reference) else {
            do {
                try save(actual, to: paths.reference)
            } catch let error {
                return failure("No reference snapshot named \(file). Did not create one: could not save snapshot named \(file), error: \(error)")
            }
            
            return failure("No reference snapshot named \(file). Created a new one.")
        }
        
        let reference: UIImage
        
        do {
            reference = try load(at: paths.reference)
        } catch let error {
            return failure("Could not load reference image for snapshot named \(file), error: \(error)")
        }
        
        if comparator.equals(actual: actual, reference: reference) {
            return .passed
        } else {
            let difference = reference.difference(with: actual)
            let failureMessage: String
            
            do {
                try save(actual, to: paths.actual)
                failureMessage = "Snapshot \(file) differs from reference"
            } catch let error {
                failureMessage = "Snapshot \(file) differs from reference, also storing actual image on disk failed: \(error)"
            }
            
            return failure(
                failureMessage,
                expected: reference,
                difference: difference
            )
        }
    }
    
    public func compare(
        actual: UIImage,
        reference: UIImage,
        comparator: SnapshotsComparator)
        -> SnapshotsComparisonResult
    {
        if comparator.equals(actual: actual, reference: reference) {
            return .passed
        } else {
            let difference = reference.difference(with: actual)
            
            return .failed(
                SnapshotsComparisonFailure(
                    message: "Actual snapshot differs from reference",
                    expectedImage: reference,
                    actualImage: actual,
                    differenceImage: difference
                )
            )
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
    
    private func load(at url: URL) throws -> UIImage {
        let data = try Data(contentsOf: url)
        
        guard let image = UIImage(data: data, scale: UIScreen.main.scale) else {
            throw ErrorString("Can not construct UIImage from data \(data)")
        }
        
        return image
    }
    
    private func save(_ image: UIImage, to url: URL) throws {
        try UIImagePNGRepresentation(image)?.write(to: url, options: [.atomic])
    }
}
