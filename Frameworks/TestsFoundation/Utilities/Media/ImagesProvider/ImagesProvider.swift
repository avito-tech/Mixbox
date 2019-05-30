import MixboxFoundation

public protocol ImagesProvider: class {
    func images() throws -> [ImageProvider]
}
