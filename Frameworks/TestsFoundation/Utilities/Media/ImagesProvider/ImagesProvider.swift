import MixboxFoundation

public protocol ImagesProvider: class {
    func images() throws -> [ImageProvider]
}

// Delegation

public protocol ImagesProviderHolder {
    var imagesProvider: ImagesProvider { get }
}

extension ImagesProvider where Self: ImagesProviderHolder {
    public func images() throws -> [ImageProvider] {
        return try imagesProvider.images()
    }
}

