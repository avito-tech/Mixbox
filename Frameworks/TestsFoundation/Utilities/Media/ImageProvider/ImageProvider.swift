import MixboxFoundation

public protocol ImageProvider: class {
    func image() throws -> UIImage
}
