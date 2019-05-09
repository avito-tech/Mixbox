import MixboxFoundation

public protocol ImagesProvider {
    func images() throws -> [ImageProvider]
}
