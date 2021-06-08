import MixboxFoundation

public protocol ImagesProvider: AnyObject {
    func images() throws -> [ImageProvider]
}

// Delegation

public protocol ImagesProviderHolder: AnyObject {
    var imagesProvider: ImagesProvider { get }
}

extension ImagesProvider where Self: ImagesProviderHolder {
    public func images() throws -> [ImageProvider] {
        return try imagesProvider.images()
    }
}
