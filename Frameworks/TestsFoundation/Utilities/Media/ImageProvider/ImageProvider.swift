import MixboxFoundation

public protocol ImageProvider {
    func image() throws -> UIImage
}
